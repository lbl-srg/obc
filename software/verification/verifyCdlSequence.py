import json
import re
import argparse
import pyfunnel as pf
# from OMPython import OMCSessionZMQ
from plotter import verification_plot
import os
import shutil
import BAC0
from buildingspy.io.outputfile import Reader
import pandas as pd
import time
import numpy as np
import datetime

#TODO: BACNET has tags in it

class VerificationTool:
    def __init__(self, config_file="config.json"):
        with open(config_file, 'r') as fp:
            self.config = json.load(fp)

        # TODO: dymola has a flag to specify output interval
        # TODO: add documentation
        # TODO: find sampling rate
        # TODO: maybe use indicator variable's value for reset'

        self.controller_config = self.config.get('controller', {})
        self.real_controller = None
        if self.controller_config != {}:
            self.initialize_controller()

        self.test_list = []
        self.parse_configurations()

        self.execute_tests()

    def initialize_controller(self):
        network_address = self.controller_config["network_address"]
        device_address = self.controller_config["device_address"]
        device_id = self.controller_config["device_id"]

        bacnet = BAC0.connect(ip=network_address)
        self.real_controller = BAC0.device(address=device_address, device_id=device_id, network=bacnet)
        self.point_properties = self.real_controller.points_properties_df().T
        # print(self.point_properties)

    def parse_configurations(self):
        references = self.config.get('references', [])
        default_tolerances = self.config.get('tolerances', None)
        default_sampling_rate = self.config.get('sampling', None)
        default_model_json_directory = self.config.get('modelJsonDirectory', None)

        for reference in references:
            ref_model = reference.get('model', None)
            ref_sequence = reference.get('sequence', None)
            ref_point_name_mapping = reference.get('pointNameMapping', None)
            ref_run_controller_flag = reference.get('run_controller', False)
            ref_controller_output = reference.get('controller_output', None)

            if ref_model is None:
                raise Exception("missing 'model' keyword for a test")
            if ref_sequence is None:
                raise Exception("missing 'sequence' keyword for a test")
            if ref_point_name_mapping is None:
                raise Exception("missing 'pointNameMapping' keyword for a test")
            if not ref_run_controller_flag and ref_controller_output is None:
                raise Exception("missing 'controller_output' keyword for a test")
            elif ref_controller_output and self.real_controller is None:
                raise Exception("missing 'controller' configuration")


            ref_outputs = reference.get('outputs', None)
            ref_sampling_rate = reference.get('sampling', None)
            ref_model_json_directory = reference.get('modelJsonDirectory', None)

            if ref_outputs is None:
                if default_tolerances is None:
                    raise Exception(
                        "missing 'tolerances' for the model: {0} and sequence: {1}".format(ref_model, ref_sequence))
                else:
                    def_output = default_tolerances
                    def_output['variable'] = ref_sequence+".*"
                    reference['outputs'] = [def_output]

            if ref_sampling_rate is None:
                if default_sampling_rate is None:
                    raise Exception(
                        "missing 'sampling' for the model: {0} and sequence: {1}".format(ref_model, ref_sequence))
                else:
                    reference['sampling'] = default_sampling_rate

            if ref_model_json_directory is None:
                if default_model_json_directory is None:
                    raise Exception(
                        "missing 'modelJsonDirectory' for the model: {0} and sequence: {1}".format(ref_model,
                                                                                                   ref_sequence))
                else:
                    reference['modelJsonDirectory'] = default_model_json_directory

            if not reference['modelJsonDirectory'].endswith('/'):
                reference['modelJsonDirectory'] += '/'

            if ref_run_controller_flag:
                reference['controller'] = self.real_controller

            self.test_list.append(reference)
        # print(self.test_list)

    def execute_tests(self):
        for test in self.test_list:
            model_dir = test.get('modelJsonDirectory')
            model_name = test.get('model')
            sequence_name = test.get('sequence')
            run_controller = test.get('run_controller')

            point_name_mapping_file = test.get('pointNameMapping')
            with open(point_name_mapping_file) as fp:
                point_name_mapping = json.load(fp)

            sample_rate = test.get('sampling')
            output_config = test.get('outputs', None)
            json_file_name = model_dir+model_name+'.json'

            test_parameters, test_io = self.extract_io(model=model_name, sequence=sequence_name, json_file=json_file_name)

            param_list = []
            for param in test_parameters:
                param_list.append(sequence_name+"."+param.get('name'))

            ip_list = []
            for ip in test_io.get('inputs'):
                ip_list.append(sequence_name+"."+ip.get('name'))

            op_list = []
            for op in test_io.get('outputs'):
                op_list.append(sequence_name+"."+op.get('name'))

            simulation_output = self.run_cdl_simulation(model=model_name, output_folder=model_dir, ip_list=ip_list, op_list=op_list, sample_time=sample_rate)

            ip_dataframe = simulation_output[ip_list]
            op_dataframe = simulation_output[op_list]

            if run_controller:
                real_outputs = self.execute_controller(inputs=ip_dataframe, op_list=op_list, point_name_mapping=point_name_mapping, sample_rate=sample_rate)
                real_outputs.to_csv('test/real_outputs.csv')
                print(real_outputs)
            else:
                real_outputs = pd.read_csv(test.get('controller_output'), index_col=0)

            # TODO: fix sampling
            op_dataframe.index = pd.to_datetime(op_dataframe.index, unit='s')
            real_outputs.index = pd.to_datetime(real_outputs.index, unit='s')

            op_dataframe = op_dataframe.resample('{}S'.format(sample_rate)).mean()
            real_outputs = real_outputs.resample('{}S'.format(sample_rate)).mean()

            validation = True
            for op in op_dataframe.columns:
                controller_point = point_name_mapping.get(op.split('.')[1], {}).get('controller_point', None)
                controller_unit = point_name_mapping.get(op.split('.')[1], {}).get('controller_unit', None)
                if controller_point is not None:
                    print("comparing {}".format(op))
                    #TODO: get correct tolerances
                    validation = validation & self.compare_single_variable(cdl_output=op_dataframe[op], actual_output=real_outputs[op],
                                                 output_config=output_config, variable=op, unit=controller_unit)
                    print("\n")
            if validation:
                print("SUCCESSFULLY VERIFIED SEQUENCE! ")

    def unit_converter(self, from_unit, to_unit, value):
        if from_unit == "degC":
            if to_unit == "degK":
                return (value + 273.15)
            elif to_unit == "degF":
                return ((value * 9.0 / 5) + 32)

        if from_unit == "degK":
            if to_unit == "degC":
                return value - 273.15
            elif to_unit == "degF":
                return (((value - 273.15) * 9.0 / 5) + 32)

        if from_unit == "degF":
            if to_unit == "degC":
                return (value - 32) * 5.0 / 9
            elif to_unit == "degK":
                return (value - 32) * 5.0 / 9 + 273.15

        if from_unit == "int":
            if to_unit == "float":
                return float(value)
            elif to_unit == "bool":
                return bool(value)

        if from_unit == "bool":
            if to_unit == "int":
                return int(value)

        if from_unit == "float":
            if to_unit == "int":
                return int(value)

    def execute_controller(self, inputs, op_list, point_name_mapping, sample_rate):

        t_start = time.time()
        t_now = time.time() - t_start

        time_index = []
        ops = {}
        while t_now <= inputs.iloc[-1].name:
            print("===========================TIME IS {}s".format(round(t_now, 2)))
            idx = inputs.loc[t_now>=inputs.index].index.values[-1]
            ip_row = inputs.loc[idx]

            for ip in inputs.columns:
                cdl_point = ip.split('.')[1]
                point_value = ip_row[cdl_point]
                controller_point = point_name_mapping.get(cdl_point, {}).get("controller_point", cdl_point)
                cdl_unit = point_name_mapping.get(cdl_point, {}).get("cdl_unit", None)
                controller_unit = point_name_mapping.get(cdl_point, {}).get("controller_unit", None)

                if cdl_unit is not None and controller_unit is not None:
                    controller_value = self.unit_converter(from_unit=cdl_unit, to_unit=controller_unit, value=point_value)
                    print("setting {0} to {1} {2}".format(cdl_point, round(controller_value, 2), controller_unit))
                else:
                    controller_value = point_value
                    print("setting {} to {}".format(controller_point, controller_value))

                self.real_controller[controller_point].write(controller_value, priority=8)

            t_now = time.time() - t_start
            for op in op_list:
                op_var = op.split('.')[1]
                controller_point = point_name_mapping.get(op_var, {}).get("controller_point", op_var)
                cdl_unit = point_name_mapping.get(op_var, {}).get("cdl_unit", None)
                controller_unit = point_name_mapping.get(op_var, {}).get("controller_unit", None)

                controller_value = self.real_controller[controller_point].value
                if cdl_unit is not None and controller_unit is not None:
                    cdl_value = self.unit_converter(from_unit=controller_unit, to_unit=cdl_unit, value=controller_value)
                else:
                    cdl_value = controller_value


                if op_var not in ops:
                    ops[op_var] = [cdl_value]
                else:
                    ops[op_var].append(cdl_value)

            time_index.append(t_now)

            time.sleep(2)
            t_now = time.time() - t_start

        for op in op_list:
            point_name = op_map[op]
            value = self.real_controller[point_name].value
            ops[op].append(value)

        time_index.append(t_now)
        print(time_index)

        op_df = pd.DataFrame(index=time_index, data=ops)
        op_df.index.name = 'time'

        return op_df

    def regex_parser(self, regex, point_list):
        r = re.compile(regex)
        selected_points = list(filter(r.match, point_list))
        return selected_points

    def compare_single_variable(self, cdl_output, actual_output, output_config, variable, unit):
        # print("in comparing")

        print("CDL OP:")
        ref_op = cdl_output.copy()
        ref_op.index = ref_op.index.strftime("%H:%M:%S")
        # ref_op = ref_op - 273.15
        print(ref_op.astype(float).round(2))

        print("\nREAL OP:")
        controller_op = actual_output.copy()
        controller_op.index = controller_op.index.strftime("%H:%M:%S")
        # controller_op = controller_op - 273.15
        print(controller_op.round(decimals=2))

        results_dir = os.path.join('.', 'tmp')
        if not os.path.exists(results_dir):
            os.mkdir(results_dir)

        for var_config in output_config:
            atolx = var_config.get('atolx', None)
            atoly = var_config.get('atoly', None)
            rtolx = var_config.get('rtolx', None)
            rtoly = var_config.get('rtoly', None)

            pf.compareAndReport(
                xReference=cdl_output.index.astype(np.int64) / 1E9,
                xTest=actual_output.index.astype(np.int64) / 1E9,
                yReference=cdl_output,
                yTest=actual_output,
                atolx=atolx,
                atoly=atoly,
                rtolx=rtolx,
                rtoly=rtoly,
                outputDirectory=results_dir)
            verification_plot(output_folder=results_dir, plot_filename='variable.pdf', y_label=variable+" [{}]".format(unit))

            try:
                assert error_df.y.max() == 0
            except:
                # TODO: maybe print report and trajectory of this output - when it fails (maybe markdown/html)
                print("FAILED assertion for {}".format(variable))
                return False

        return True
        # shutil.rmtree(results_dir)

    def extract_io(self, model, sequence, json_file):
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
            raise Exception('could not find sequence in json File')

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
        # print("in running cdl simulation")
        # omc = OMCSessionZMQ()
        # omc.sendExpression("loadModel(Buildings)")
        # omc.sendExpression("simulate({}, outputFormat=\"mat\")".format(model))
        # Copy output file
        # shutil.move("{}_res.mat".format(model), output_folder+"/{}_res.mat".format(model))

        r = Reader(output_folder+"/{}_res.mat".format(model), 'dymola')

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
        # simulation_output = simulation_output.drop_duplicates(keep='last')
        simulation_output.to_csv(output_folder+"/{}_res.csv".format(model))
        simulation_output.index = simulation_output.index.astype(float)
        simulation_output.index.name = 'time'

        return simulation_output

if __name__ == "__main__":
    args_parser = argparse.ArgumentParser()
    args_parser.add_argument("-c", "--config", help="config file name")

    args = args_parser.parse_args()
    config_file = args.config

    test = VerificationTool(config_file=config_file)
    # test.start_test()

