import json
import re
import argparse

class VerificationTool:
    def __init__(self, config_file="config.json"):
        with open(config_file, 'r') as fp:
            self.config = json.load(fp)

        self.test_list = []
        self.parse_configurations()
        self.initialize_tests()

        print(self.test_list)

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

            ref_tolerance = reference.get('tolerances', None)
            ref_sampling_rate = reference.get('sampling', None)
            ref_model_json_directory = reference.get('modelJsonDirectory', None)

            if ref_tolerance is None:
                if default_tolerances is None:
                    raise Exception(
                        "missing 'tolerances' for the model: {0} and sequence: {1}".format(ref_model, ref_sequence))
                else:
                    reference['tolerances'] = default_tolerances

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

    def initialize_tests(self):
        for test in self.test_list:
            model_dir = test.get('modelJsonDirectory')
            model_name = test.get('model')
            sequence_name = test.get('sequence')
            json_file_name = model_dir+model_name+'.json'

            with open(json_file_name) as fp:
                model_json = json.load(fp)

            public_models = []
            found = False
            for json_output in model_json:
                if json_output.get('topClassName') == model_name:
                    found = True
                    public_models = json_output.get('public', {}).get('models', [])
                    break

            if not found:
                raise Exception(
                    "cannot find json output of model: {0} in json file: {1}".format(model_name, json_file_name))

            for public_model in public_models:
                if public_model['name'] == sequence_name:
                    print(public_model)
                    #TODO: extract io, parameters
            print()

    def regex_parser(self, regex, point_list):
        r = re.compile(regex)
        selected_points = list(filter(r.match, point_list))
        return selected_points

if __name__ == "__main__":
    args_parser = argparse.ArgumentParser()
    args_parser.add_argument("-c", "--config", help="config file name")

    args = args_parser.parse_args()
    config_file = args.config

    test = VerificationTool(config_file=config_file)
    #test.start_test()

