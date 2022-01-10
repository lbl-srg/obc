#!/usr/bin/python3
#####################################################################
# This script copies the Annex 60 library to the Buildings library.
#
# Todo: copy unit tests and test results.
#       - copy Images directory
#
# MWetter@lbl.gov                                          2014-03-05
#####################################################################

import buildingspy.development.refactor as r

#r.move_class("Buildings.ThermalZones.EnergyPlus.BaseClasses.FMUZoneClass",
#             "Buildings.ThermalZones.EnergyPlus.BaseClasses.SpawnExternalObject")

#r.move_class("Buildings.ThermalZones.EnergyPlus.Examples.OneZoneRadiantFloor",
#             "Buildings.ThermalZones.EnergyPlus.Examples.OneZoneRadiantHeatingCooling")
r.move_class("SystemModel.Validation.VAVOnly",
             "SystemModel.VAV.Validation.System")
