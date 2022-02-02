import json
import re
import argparse
import pyfunnel as pf
from plotter import verification_plot
from openmodelica_sim import execute_omc
import os
import subprocess
import shutil
import BAC0
from buildingspy.io.outputfile import Reader
import pandas as pd
import time
import numpy as np
import datetime

class Verification_Tool:
    def __init__(self, config_file="config.json"):
        with open(config_file, 'r') as fp:
            self.config = json.load(fp)

        # TODO: dymola has a flag to specify output interval
        # TODO: find sampling rate

        self.controller_config = self.config.get('controller', {})
        self.modelica_json_path = os.environ.get('MODELICAJSONPATH', '.')
        self.real_controller = None
        if self.controller_config != {}:
            self.initialize_controller()

        self.test_list = []
        self.parse_configurations()

        self.execute_tests()

    def initialize_controller(self):
        """Initialize the real controller."""
        network_address = self.controller_config["networkAddress"]
        device_address = self.controller_config["deviceAddress"]
        device_id = self.controller_config["deviceId"]

        bacnet = BAC0.connect(ip=network_address)
        self.real_controller = BAC0.device(address=device_address, device_id=device_id, network=bacnet)
        self.point_properties = self.real_controller.points_properties_df().T

    def parse_configurations(self):
        """Parse the configuration file to extract sequences to test, tolerances, point maps and json translations."""
        references = self.config.get('references', [])
        default_tolerances = self.config.get('tolerances', None)
        default_sampling_rate = self.config.get('sampling', None)
        default_model_json_directory = self.config.get('modelJsonDirectory', None)

        for reference in references:
            ref_model = reference.get('model', None)
            ref_sequence = reference.get('sequence', None)
            ref_point_name_mapping = reference.get('pointNameMapping', None)
            ref_run_controller_flag = reference.get('runController', False)
            ref_controller_output = reference.get('controllerOutput', None)

            if ref_model is None:
                raise Exception("Missing 'model' keyword for a test.")
            if ref_sequence is None:
                raise Exception("Missing 'sequence' keyword for a test.")
            if ref_point_name_mapping is None:
                raise Exception("Missing 'pointNameMapping' keyword for a test.")
            if not ref_run_controller_flag and ref_controller_output is None:
                raise Exception("Missing 'controllerOutput' keyword for a test.")
            elif ref_run_controller_flag and self.real_controller is None:
                raise Exception("Missing 'controller' configuration.")

            ref_outputs = reference.get('outputs', None)
            ref_sampling_rate = reference.get('sampling', None)
            ref_model_json_directory = reference.get('modelJsonDirectory', None)

            if ref_outputs is None and default_tolerances is None:
                raise Exception(
                    "Missing 'tolerances' for the model: {0} and sequence: {1}.".format(ref_model, ref_sequence))
            elif ref_outputs is None:
                reference['outputs'] = {ref_sequence+".*": default_tolerances}
            else:
                reference['outputs'][ref_sequence + ".*"] = default_tolerances

            if ref_sampling_rate is None:
                if default_sampling_rate is None:
                    raise Exception(
                        "Missing 'sampling' for the model: {0} and sequence: {1}.".format(ref_model, ref_sequence))
                else:
                    reference['sampling'] = default_sampling_rate

            if ref_model_json_directory is None:
                if default_model_json_directory is None:
                    raise Exception(
                        "Missing 'modelJsonDirectory' for the model: {0} and sequence: {1}.".format(ref_model,
                                                                                                   ref_sequence))
                else:
                    reference['modelJsonDirectory'] = default_model_json_directory

            if not reference['modelJsonDirectory'].endswith(os.sep):
                reference['modelJsonDirectory'] += os.sep

            if ref_run_controller_flag:
                reference['controller'] = self.real_controller

            self.test_list.append(reference)

    def run_modelica_json(self, model, model_dir):
        """This function uses the modelica-json tool to convert modelica files to json.

        Parameters:
        -----------
        model : str
                Name of modelica model to be translated to json.
        model_dir : str
                Directory where to store the json output.
        """
        app_js_path = os.path.join(self.modelica_json_path, 'app.js')
        model_path = model.replace('.', os.sep) + '.mo'
        print("Running modelica-json tool for {0}.".format(model))
        result = subprocess.run(['node', '{}'.format(app_js_path), '-f', '{}'.format(model_path),
                                 '-d', '{}'.format(model_dir), '-o', 'json'],
                                stdout=subprocess.PIPE, shell=False)

        shutil.move(os.path.join(model_dir, 'json', model+'.json'), os.path.join(model_dir, model+'.json'))
        if len(os.listdir(os.path.join(model_dir, 'json'))) == 0:
            os.rmdir(os.path.join(model_dir, 'json'))

        if result.returncode != 0:
            raise Exception("Error while converting modelica file to json = {0}.".format(result.stdout.decode("utf-8")))
        else:
            print("Successfully generated json file for {}.".format(model))


    def execute_tests(self):
        """Run each test for the particular sequence by running the CDL simulation and then comparing these reference
        outputs to outputs generated by the controller in this process or that was archived in a csv file."""
        for test in self.test_list:
            model_dir = test.get('modelJsonDirectory')
            generate_json = test.get('generateJson', True)
            model_name = test.get('model')
            sequence_name = test.get('sequence')
            run_controller = test.get('runController')

            if generate_json:
                self.run_modelica_json(model=model_name, model_dir=model_dir)

            point_name_mapping_file = test.get('pointNameMapping')
            with open(point_name_mapping_file) as fp:
                point_name_mapping_list = json.load(fp)

            point_name_mapping = {}
            for point_dict in point_name_mapping_list:
                cdl_name = point_dict["cdl"].get("name")
                point_name_mapping[cdl_name] = point_dict

            sample_rate = test.get('sampling')
            tolerance_config = test.get('outputs', None)
            indicator_config = test.get('indicators', {})
            json_file_name = model_dir+model_name+'.json'

            test_parameters, test_io = self.extract_io(model=model_name, sequence=sequence_name, json_file=json_file_name)

            param_list = []
            for param in test_parameters:
                param_list.append(sequence_name+"."+param.get('name'))

            ip_list = []
            for ip in test_io.get('inputs'):
                ip_name = ip.get('name')
                if ip_name in list(point_name_mapping.keys()):
                    ip_list.append(sequence_name+"."+ip_name)
                    unit = ip.get("unit", None)
                    if unit is not None:
                        unit_from_seq = unit.get('value').split('"')[1]
                        unit_from_cfg = point_name_mapping[ip_name].get("cdl", {}).get("unit", None)
                        if unit_from_cfg != unit_from_seq:
                            raise Exception("CDL units don't match in CDL json file and pointNameMapping json file for {}.".format(ip_name))

            op_list = []
            for op in test_io.get('outputs'):
                op_name = op.get('name')
                if op_name in list(point_name_mapping.keys()):
                    op_list.append(sequence_name+"."+op_name)

            output_variable_configurations = {}
            for op in op_list:
                output_variable_configurations[op] = tolerance_config[sequence_name+'.*'].copy()

            for op_regex in tolerance_config:
                if op_regex != sequence_name+".*":
                    filtered_ops = self.regex_parser(regex=op_regex, point_list=op_list)
                    for op in filtered_ops:
                        tol = tolerance_config[op_regex]
                        for tol_variable in tol:
                            output_variable_configurations[op][tol_variable] = tol[tol_variable]

            for op in op_list:
                output_variable_configurations[op]['indicators'] = indicator_config.get(sequence_name + '.*', []).copy()

            for op_regex in indicator_config:
                if op_regex != sequence_name+".*":
                    filtered_ops = self.regex_parser(regex=op_regex, point_list=op_list)
                    for op in filtered_ops:
                        indicators = indicator_config[op_regex]
                        output_variable_configurations[op]['indicators'] = indicators

            simulation_output = self.run_cdl_simulation(model=model_name, output_folder=model_dir, ip_list=ip_list, op_list=op_list, sample_time=sample_rate)
            simulation_output.index = pd.to_datetime(simulation_output.index, unit='s')

            ip_dataframe = simulation_output[ip_list]
            op_dataframe = simulation_output[op_list]

            if run_controller:
                real_outputs = self.execute_controller(inputs=ip_dataframe, op_list=op_list, point_name_mapping=point_name_mapping, sample_rate=sample_rate)
                real_outputs.to_csv(test.get('controllerOutput', '{0}_real_outputs.csv'.format(sequence_name)))
            else:
                real_outputs = pd.read_csv(test.get('controllerOutput'), index_col=0)

            # TODO: fix sampling
            real_outputs.index = pd.to_datetime(real_outputs.index, unit='s')

            ip_dataframe = ip_dataframe.resample('{}S'.format(sample_rate)).mean()
            op_dataframe = op_dataframe.resample('{}S'.format(sample_rate)).mean()
            real_outputs = real_outputs.resample('{}S'.format(sample_rate)).mean()

            validation = True
            for op in op_dataframe.columns:
                device_point_name = point_name_mapping.get(op.split('.')[1], {}).get('device', {}).get("name", None)
                cdl_point_unit = point_name_mapping.get(op.split('.')[1], {}).get('cdl', {}).get("unit", "")
                if device_point_name is not None:
                    print("Comparing output {}:".format(op))

                    cdl_output = op_dataframe[op]
                    actual_output = real_outputs[op]

                    for indicator_variable in output_variable_configurations[op]['indicators']:
                        cdl_output = cdl_output * ip_dataframe[indicator_variable]
                        actual_output = actual_output * ip_dataframe[indicator_variable]

                    validation = validation & self.compare_single_variable(cdl_output=cdl_output,
                                                                           actual_output=actual_output,
                                                                           output_config=output_variable_configurations[op],
                                                                           variable=device_point_name,
                                                                           unit=cdl_point_unit,
                                                                           output_folder=model_dir)
                    print("\n")
            if validation:
                print("Sequence conforms to the specification!")

    def unit_converter(self, from_unit, to_unit, value):
        """This function converts values from one unit to another.

        Parameters
        ----------
        from_unit : str
                Current unit of the specified value.
        to_unit : str
                Unit to convert the value to.
        value
                Value to be converted to 'to_unit'.

        Returns
        -------
        value
                Converted value.
        """

        if from_unit is None or to_unit is None:
            return value

        if from_unit == to_unit:
            return value

        if from_unit == "degC":
            if to_unit == "K":
                return (value + 273.15)
            elif to_unit == "degF":
                return ((value * 9.0 / 5) + 32)

        if from_unit == "K":
            if to_unit == "degC":
                return value - 273.15
            elif to_unit == "degF":
                return (((value - 273.15) * 9.0 / 5) + 32)

        if from_unit == "degF":
            if to_unit == "degC":
                return (value - 32) * 5.0 / 9
            elif to_unit == "K":
                return (value - 32) * 5.0 / 9 + 273.15

        if from_unit == "m3/s":
            if to_unit == "cfm":
                return value * 2118.88

        if from_unit == "cfm":
            if to_unit == "m3/s":
                return value / 2118.88

        if from_unit ==  "1":
            if to_unit == "%":
                return value*100

        if from_unit == "%":
            if to_unit == "1":
                return value/100

    def type_converter(self, from_type, to_type, value):
        """This function converts values from one data-type to another.

        Parameters
        ----------
        from_type : str
                Current type of the specified value.
        to_type : str
                Type to convert the value to.
        value
                Value to be converted to 'to_type'.

        Returns
        -------
        value
                Converted value.
        """

        if from_type == to_type:
            return value

        if from_type == "int":
            if to_type == "float":
                return float(value)
            elif to_type == "str_active_inactive":
                if value == 1:
                    return 'active'
                else:
                    return 'inactive'
            elif to_type == "str_occupied_unoccupied":
                if value == 0:
                    return 'Unoccupied'
                else:
                    return 'Occupied'

        if from_type == "str_active_inactive":
            if to_type == "int":
                if value == 'active':
                    return 1
                else:
                    return 0

        if from_type == "str_occupied_unoccupied":
            if to_type == 'int':
                if value == 'Occupied':
                    return 1
                else:
                    return 0

        if from_type == "float":
            if to_type == "int":
                return int(value)

    def execute_controller(self, inputs, op_list, point_name_mapping, sample_rate):
        """This function interacts with a real controller device by setting and reading values.

        Parameters
        ----------
        inputs : pd.DataFrame
                Timeseries of inputs from the CDL simulation.
        op_list : list
                List of output variables.
        point_name_mapping : dict
                Dictionary containing point name, unit and type mapping for each input and output variable.
        sample_rate :  int
                Rate at which values are read from the controller.

        Returns
        -------
        op_df : pd.DataFrame
                Timeseries of output values from the controller device based on CDL simulation inputs.
        """

        t_start = time.time()
        t_now = time.time() - t_start

        time_index = []
        ops = {}
        last_ts = inputs.iloc[-1].name 
        while pd.to_datetime(t_now) <= last_ts:
            print("===========================TIME IS {}s".format(round(t_now, 2)))
            idx = inputs.loc[pd.to_datetime(t_now)>=inputs.index].index.values[-1]
            ip_row = inputs.loc[idx]

            for ip in inputs.columns:
                cdl_point_name = ip.split('.')[1]
                point_value = ip_row[ip]
                point_cfg = point_name_mapping[cdl_point_name]

                cdl_point_unit = point_cfg.get("cdl").get("unit")
                cdl_point_type = point_cfg.get("cdl").get("type")

                device_point_name = point_cfg.get("device").get("name")
                device_point_unit = point_cfg.get("device").get("unit")
                device_point_type = point_cfg.get("device").get("type")

                device_value = self.unit_converter(from_unit=cdl_point_unit, to_unit=device_point_unit, value=point_value)
                device_value = self.type_converter(from_type=cdl_point_type, to_type=device_point_type, value=device_value)

                print("{0}: {1}, {2}: {3} ".format(cdl_point_name, point_value, device_point_name, device_value))
                try:
                    self.real_controller[device_point_name].write(device_value, priority=8)
                except: 
                    self.real_controller[device_point_name] = device_value

            t_now = time.time() - t_start
            for op in op_list:
                cdl_point_name = op.split('.')[1]
                point_cfg = point_name_mapping[cdl_point_name]

                cdl_point_unit = point_cfg.get("cdl").get("unit")
                cdl_point_type = point_cfg.get("cdl").get("type")

                device_point_name = point_cfg.get("device").get("name")
                device_point_unit = point_cfg.get("device").get("unit")
                device_point_type = point_cfg.get("device").get("type")

                device_value = self.real_controller[device_point_name].value

                cdl_value = self.unit_converter(from_unit=device_point_unit, to_unit=cdl_point_unit, value=device_value)
                cdl_value = self.type_converter(from_type=device_point_type, to_type=cdl_point_type, value=cdl_value)

                if cdl_point_name not in ops:
                    ops[cdl_point_name] = [cdl_value]
                else:
                    ops[cdl_point_name].append(cdl_value)

            time_index.append(t_now)
            time.sleep(sample_rate)
            t_now = time.time() - t_start

        for op in op_list:
            cdl_point_name = op.split('.')[1]
            point_cfg = point_name_mapping[cdl_point_name]

            cdl_point_unit = point_cfg.get("cdl").get("unit")
            cdl_point_type = point_cfg.get("cdl").get("type")

            device_point_name = point_cfg.get("device").get("name")
            device_point_unit = point_cfg.get("device").get("unit")
            device_point_type = point_cfg.get("device").get("type")

            device_value = self.real_controller[device_point_name].value

            cdl_value = self.unit_converter(from_unit=device_point_unit, to_unit=cdl_point_unit, value=device_value)
            cdl_value = self.type_converter(from_type=device_point_type, to_type=cdl_point_type, value=cdl_value)

            ops[cdl_point_name].append(cdl_value)

        time_index.append(t_now)
        print(time_index)

        op_df = pd.DataFrame(index=time_index, data=ops)
        op_df.index.name = 'time'

        return op_df

    def regex_parser(self, regex, point_list):
        """This function filters points based on a regular-expression.

        Parameters
        ----------
        regex : str
                Regular expression used to filter the necessary points.
        point_list : list
                List containing all elements (points from CDL simulation).

        Returns
        -------
        selected_points : list
                Subset of points after filtering, based on the regex.
        """
        r = re.compile(regex)
        selected_points = list(filter(r.match, point_list))
        return selected_points

    def compare_single_variable(self, cdl_output, actual_output, output_config, variable, unit, output_folder):
        """Compares one output variable from CDL simulation (reference) against controller device generated output,
        and correspondingly produces comparison and error charts.

        Parameters
        ----------
        cdl_output : pd.Series
                Reference timeseries of an output variable obtained from cdl simulation.
        actual_output : pd.Series
                Timeseries of the same output variable obtained from the controller device.
        output_config : dict
                Absolute and relative tolerance configuration for the output variable.
        variable : str
                Variable name to be added to chart axis label.
        unit : str
                Variable unit in CDL to be added to the chart axis label.
        Returns
        -------
        success_failure : bool
                True if the actual output is within bounds of the reference output all the time, else False.
        """

        print("CDL OP:")
        ref_op = cdl_output.copy()
        ref_op.index = ref_op.index.strftime("%H:%M:%S")
        print(ref_op.astype(float).round(2))

        print("\nREAL OP:")
        controller_op = actual_output.copy()
        controller_op.index = controller_op.index.strftime("%H:%M:%S")
        print(controller_op.round(decimals=2))

        errors_dir = os.path.join('.', 'tmp')
        if not os.path.exists(errors_dir):
            os.mkdir(errors_dir)

        atolx = output_config.get('atolx', None)
        atoly = output_config.get('atoly', None)
        rtolx = output_config.get('rtolx', None)
        rtoly = output_config.get('rtoly', None)

        pf.compareAndReport(
            xReference=cdl_output.index.astype(np.int64) / 1E9,
            xTest=actual_output.index.astype(np.int64) / 1E9,
            yReference=cdl_output,
            yTest=actual_output,
            atolx=atolx,
            atoly=atoly,
            rtolx=rtolx,
            rtoly=rtoly,
            outputDirectory=errors_dir)
        verification_plot(error_folder=errors_dir, output_folder=output_folder, plot_filename='{}.pdf'.format(variable),
                          y_label="{0} [{1}]".format(variable, unit))

        shutil.rmtree('tmp')
        try:
            assert error_df.y.max() == 0
        except:
            # TODO: maybe print report and trajectory of this output - when it fails (maybe markdown/html)
            print("FAILED assertion for {}.".format(variable))
            return False

        return True
        # shutil.rmtree(results_dir)

    def extract_io(self, model, sequence, json_file):
        """Extracts inputs, ouputs and parameters from the json translation of the modelica file for the particular
        test sequence.

        Parameters
        ----------
        model : str
                Name of the modelica model.
        sequence : str
                Name of the sequence being tested within the modelica model.
        json_file : str
                Filename of the json translation of the modelica model.
        Returns
        -------
        test_parameters : list
                List of parameters extracted from the json file.
        test_io : dict
                Dictionary with 2 keys: 'inputs' (input variables for the sequence) and 'ouputs' (output variables for the sequence).
        """
        # print("in extract_io")
        with open(json_file) as fp:
            json_ops = json.load(fp)

        test_model = {}
        for json_op in json_ops:
            top_class_name = json_op.get('topClassName')
            if top_class_name == model:
                json_models = json_op.get('public', {}).get('models', [])
                for json_model in json_models:
                    if json_model.get('name', '') == sequence:
                        test_model = json_model
                        break

        test_parameter_modifications = test_model.get('modifications')

        if test_model == {}:
            raise Exception('Could not find sequence in json File.')

        test_parameters = {}
        test_inputs = {}
        test_outputs = {}

        test_model_name = test_model.get('className')
        for json_op in json_ops:
            top_class_name = json_op.get('topClassName')
            if top_class_name == test_model_name:
                test_parameters = json_op.get('public', {}).get('parameters', {})
                test_inputs = json_op.get('public', {}).get('inputs', {})
                test_outputs = json_op.get('public', {}).get('outputs', {})
                break

        parameter_list = []
        for parameter in test_parameters:
            name = parameter.get('name')
            parameter_list.append(name)

            for modification in test_parameter_modifications:
                if name == modification.get('name'):
                    parameter['value'] = modification.get('value')

        test_io = {"inputs": test_inputs, "outputs": test_outputs}
        return test_parameters, test_io

    def run_cdl_simulation(self, model, output_folder, ip_list, op_list, sample_time):
        """This function runs the CDL simulation using OpenModelica; also converts the .mat output file to .csv.

        Parameters
        ----------
        model : str
                Name of the modelica model.
        output_folder : str
                Name of the folder where the generated mat file with the results will be saved.
        ip_list : list
                List of input variables for this model.
        op_list : list
                List of output variables for this model.
        sample_time : int
                Sampling time in seconds.
        Returns
        -------
        simulation_output : pd.DataFrame
                Timeseries of input and output variable values from the CDL simulation.
        """
        execute_omc(model, output_folder)

        r = Reader(os.path.join(output_folder, "{}_res.mat".format(model)), 'dymola')

        df_list = []
        for ip in ip_list:
            values = r.values(ip)
            df = pd.DataFrame(index=values[0], data={ip: values[1]})
            df_list.append(df)
        for op in op_list:
            values = r.values(op)
            df = pd.DataFrame(index=values[0], data={op: values[1]})
            df_list.append(df)

        simulation_output = pd.concat(df_list, axis=1).fillna(method='ffill')
        simulation_output = simulation_output.loc[~simulation_output.index.duplicated(keep='first')]
        simulation_output.to_csv(os.path.join(output_folder, "{}_res.csv".format(model)))
        simulation_output.index = simulation_output.index.astype(float)
        simulation_output.index.name = 'time'

        return simulation_output

if __name__ == "__main__":
    args_parser = argparse.ArgumentParser()
    args_parser.add_argument("-c", "--config", help="config file name")

    args = args_parser.parse_args()
    config_file = args.config

    test = Verification_Tool(config_file=config_file)

