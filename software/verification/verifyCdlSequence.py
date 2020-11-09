import json
import re
import argparse
# import pyfunnel
# from OMPython import OMCSessionZMQ
import os
import shutil
import BAC0

class VerificationTool:
    def __init__(self, config_file="config.json"):
        with open(config_file, 'r') as fp:
            self.config = json.load(fp)

        self.test_list = []
        self.parse_configurations()

        self.controller_config = self.config.get('controller', {})
        self.real_controller = None
        if self.controller_config != {}:
            self.initialize_controller()

        self.execute_tests()

    def initialize_controller(self):
        network_address = self.controller_config["network_address"]
        device_address = self.controller_config["device_address"]
        device_id = self.controller_config["device_id"]

        bacnet = BAC0.connect(ip=network_address)
        self.real_controller = BAC0.device(address=device_address, device_id=device_id, network=bacnet)
        self.point_properties = self.real_controller.points_properties_df().T
        print(self.point_properties)

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
        print(self.test_list)

    def execute_tests(self):
        for test in self.test_list:
            model_dir = test.get('modelJsonDirectory')
            model_name = test.get('model')
            sequence_name = test.get('sequence')
            run_controller = test.get('run_controller')
            point_name_mapping = reference.get('pointNameMapping')
            sample_rate = reference.get('sampling')
            output_config = reference.get('outputs', None)
            json_file_name = model_dir+model_name+'.json'

            test_parameters, test_io = self.extract_io(model=model_name, sequence=sequence_name, json_file=json_file_name)

            simulation_output = self.run_cdl_simulation(model=model_name, output_folder=model_dir)


            param_list = []
            for param in test_parameters:
                param_list.append(sequence_name+"."+param.get('name'))

            ip_list = []
            for ip in test_io.get('inputs'):
                ip_list.append(sequence_name+"."+ip.get('name'))

            op_list = []
            for op in test_io.get('outputs'):
                op_list.append(sequence_name+"."+op.get('name'))

            ip_dataframe = simulation_output[ip_list]
            op_dataframe = simulation_output[op_list]

            if run_controller:
                real_outputs = self.execute_controller(inputs=ip_dataframe, point_name_mapping=point_name_mapping, sample_rate=sample_rate)

            for op in op_dataframe.columns:
                self.compare_single_variable(cdl_output=op_dataframe[op], actual_output=real_outputs[op], output_config=output_config)


    def execute_controller(self, inputs, point_name_mapping, sample_rate):
        new_col_list = []
        for col in inputs.columns:
            new_col_list.append(point_name_mapping.get(col))

        ip_df  = inputs.copy()
        ip_df.columns = new_col_list

        t_start = time.time()
        t_now = time.time() - t_start
        ops = []
        while t_now <= ip_df.iloc[-1].index.values[0]:
            ip_row = ip_df.loc[t_now>=ip_df.index][0]
            for ip in ip_row.columns:
                self.real_controller[ip] = ip_row[ip]

            ops.append(self.real_controller.points)
            time.sleep(sample_rate)
            t_now = time.time() - t_start

        return ops

    def regex_parser(self, regex, point_list):
        r = re.compile(regex)
        selected_points = list(filter(r.match, point_list))
        return selected_points

    def compare_single_variable(self, cdl_output, actual_output, output_config):
        results_dir = os.path.join('.', 'tmp')
        os.mkdir(results_dir)


        for var_config in output_config:
            variable = var_config.get('variable')
            atolx = var_config.get('atolx', None)
            atoly = var_config.get('atoly', None)
            rtolx = var_config.get('rtolx', None)
            rtoly = var_config.get('rtoly', None)

            pf.compareAndReport(
                xReference=cdl_output.index.astype(np.int64) / 1E9,
                xTest=actual_output.index.astype(np.int64) / 1E9,
                yReference=cdl_output[variable],
                yTest=actual_output[variable],
                atolx=atolx,
                atoly=atoly,
                rtolx=rtolx,
                rtoly=rtoly,
                outputDirectory=results_dir)
        error_df = pd.read_csv(os.path.join(results_dir, 'errors.csv'))
        assert error_df.y.max() == 0
        shutil.rmtree(results_dir)

    def extract_io(self, model, sequence, json_file):
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

    def run_cdl_simulation(self, model, output_folder):
        omc = OMCSessionZMQ()
        omc.sendExpression("loadModel(Buildings)")
        omc.sendExpression("simulate({}, outputFormat=\"csv\")".format(model))
        # Copy output file
        shutil.move("{}_res.csv".format(model), output_folder+"/{}_res.csv".format(model))
        simulation_output = pd.read_csv(output_folder+"/{}_res.csv".format(model), index_col=0)
        simulation_output.index = pd.to_datetime(simulation_output.index)
        return simulation_output

if __name__ == "__main__":
    args_parser = argparse.ArgumentParser()
    args_parser.add_argument("-c", "--config", help="config file name")

    args = args_parser.parse_args()
    config_file = args.config

    test = VerificationTool(config_file=config_file)
    # test.start_test()

