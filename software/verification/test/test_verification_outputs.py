import unittest
import json
import os
from verify_cdl_sequence import Verification_Tool
import shutil

class Test_verification_outputs(unittest.TestCase):
    def test_verification_tool(self):
        """Unit test to runs the tool for the config_test.json that should produce a failed verification.
        The real controller outputs are stored in test/real_outputs.csv"""
        config_file = 'config_test.json'

        test = Verification_Tool(config_file=config_file)

        with open(config_file, "r") as fp:
            config = json.load(fp)

        model = config.get('references', [{}])[0].get('model', 'Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.Validation.ZoneTemperatures')
        output_folder = config.get('modelJsonDirectory', 'test')

        if os.path.exists(output_folder):
            for fp in os.listdir(output_folder):
                if fp.startswith(model):
                    os.remove(os.path.join(output_folder, fp))

        print("Running the Verification Tool")
        test_result = test.execute_tests()

        files = os.listdir(output_folder)

        print("checking if the verification failed as expected:")
        self.assertFalse(test_result[0])
        print("Verification failed!")

        print("checking if all the necessary files have been created: ")

        self.assertTrue("{}.json".format(model) in files)
        self.assertTrue("{}_res.mat".format(model) in files)
        self.assertTrue("{}_res.csv".format(model) in files)
        self.assertTrue("Effective Cooling Setpoint_1.pdf" in files)
        self.assertTrue("Effective Heating Setpoint_1.pdf" in files)
        print("all the expected files have been generated!")