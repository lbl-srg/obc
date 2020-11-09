import json
import re
import argparse
# import pyfunnel
import os
import shutil
import BAC0

class VerificationTool:
    def __init__(self, config_file="config.json", run_controller=False):
        with open(config_file, 'r') as fp:
            self.config = json.load(fp)

        self.test_list = []
        self.parse_configurations()
        self.run_controller = run_controller

        if self.run_controller:
            self.controller_config = self.config.get('controller', {})
            self.initialize_controller()

        self.execute_tests()

    def initialize_controller(self):
        network_address = self.controller_config["network_address"]
        device_address = self.controller_config["device_address"]
        device_id = self.controller_config["device_id"]

        bacnet = BAC0.connect(ip=network_address)
        self.device = BAC0.device(address=device_address, device_id=device_id, network=bacnet)
        self.point_properties = self.device.points_properties_df().T
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

            if ref_model is None:
                raise Exception("missing 'model' keyword for a test")
            if ref_sequence is None:
                raise Exception("missing 'sequence' keyword for a test")
            if ref_point_name_mapping is None:
                raise Exception("missing 'pointNameMapping' keyword for a test")

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

            self.test_list.append(reference)
        print(self.test_list)

    def execute_tests(self):
        for test in self.test_list:
            model_dir = test.get('modelJsonDirectory')
            model_name = test.get('model')
            sequence_name = test.get('sequence')
            json_file_name = model_dir+model_name+'.json'

            test_parameters, test_io = self.extract_io(model=model_name, sequence=sequence_name, json_file=json_file_name)
            for param in test_parameters:
                print(param.get('name'))

            for ip in test_io.get('inputs'):
                print(ip.get('name'))

            for op in test_io.get('outputs'):
                print(op.get('name'))

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

if __name__ == "__main__":
    args_parser = argparse.ArgumentParser()
    args_parser.add_argument("-c", "--config", help="config file name")
    args_parser.add_argument("--run_controller", help="if chosen, the inputs will be set to the controller", default=False, action="store_true")

    args = args_parser.parse_args()
    config_file = args.config
    run_controller = args.run_controller

    test = VerificationTool(config_file=config_file, run_controller=run_controller)
    # test.start_test()

