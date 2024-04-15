#!/usr/bin/env python
# coding: utf-8

"""Generate combinations and run simulations.

This script shall be run from the directory `modelica-buildings/Buildings`,
i.e., where the top-level `package.mo` file can be found.

Args:
    - See docstring of core.py for the optional positional arguments of this script.

Returns:
    - 0 if all simulations succeed.
    - 1 otherwise.

Details:
    The script performs the following tasks.
    - Generate all possible combinations of class modifications based on a set of
      parameter bindings and redeclare statements provided in `MODIF_GRID`.
    - Exclude the combinations based on a match with the patterns provided in `EXCLUDE`.
    - This allows excluding unsupported configurations.
    - Exclude the class modifications based on a match with the patterns provided in `REMOVE_MODIF`,
      and prune the resulting duplicated combinations.
    - This allows reducing the number of simulations by excluding class modifications that
      yield the same model, i.e., modifications to parameters that are not used (disabled) in
      the given configuration.
    - For the remaining combinations: run the corresponding simulations for the models in `MODELS`.
"""

from s223ToMo import *
from queryS223VAVBox import *
from jinja2 import Environment, FileSystemLoader
import os
import yaml

if __name__ == "__main__":
    with open("config.yaml") as fp:
        config = yaml.safe_load(fp)  

    mblVersion = config.get('mblVersion', '10.0.0')
    semanticModelFile = config.get('semanticModel')
    templateFolder = config.get('templateFolder', 'moFileTemplates')
    
    g = rdflib.Graph()
    g.parse(semanticModelFile, format='ttl')
    configurations = {}
    vavs = getAllVavs(g)

    for vav in vavs:
        sensorsAndProperties = getAllPropertiesAndSensors(g, vav)
        containsReheat = checkIfReheatCoilPresent(g, vav)
        electriReheatCoils = getElectricHeatingCoil(g, vav)
        
        if containsReheat:
            configurations[vav] = {
                'reheat': True,
                'sensors': sensorsAndProperties
            }
            if len(electriReheatCoils) > 0:
                configurations[vav]['electricReheat'] = True
            else:
                configurations[vav]['electricReheat'] = False
        else:
             configurations[vav] = {
                'reheat': False,
                'sensors': sensorsAndProperties
            }


    environment = Environment(loader=FileSystemLoader(templateFolder))
    packageTemplate = environment.get_template("packageTemplate.template")
    vavTemplate = environment.get_template("VAVBoxTemplate.template")

    packageName = semanticModelFile.split('.')[0]

    packageMoText = packageTemplate.render(
                packageName=packageName,
                mblVersion=mblVersion
            )

    if not os.path.exists(packageName):
        print("creating package directory for {0}".format(packageName))
        os.mkdir(packageName)

    with open(os.path.join(packageName, 'package.mo'), 'w') as fp:
        print("creating package.mo")
        fp.write(packageMoText)

    for vav in configurations:
        config = configurations.get(vav)
        reheat = config.get('reheat')
        electriReheatCoil = config.get('electricReheat', False)
        vavName = vav.replace(':', '_').replace('/', '_').replace('-', '_')
        MODELS = []
        model = ""
        
        if reheat:
            model = 'Buildings.Templates.ZoneEquipment.Validation.VAVBoxReheat'
        else:
             model = 'Buildings.Templates.ZoneEquipment.Validation.VAVBoxCoolingOnly'
        MODELS.append(model)
        
        vavSensors = config.get('sensors')
        MODIF_GRID = {model: {}}
        for sensor in ['occupancy', 'window', 'CO2']:
            if sensor == 'occupancy':
                if sensor in vavSensors:
                    MODIF_GRID[model]['VAVBox_1__ctl__have_occSen']=['true']
                else:
                    MODIF_GRID[model]['VAVBox_1__ctl__have_occSen']=['false']
                    
            if sensor == 'window':
                if sensor in vavSensors:
                    MODIF_GRID[model]['VAVBox_1__ctl__have_winSen']=['true']
                else:
                    MODIF_GRID[model]['VAVBox_1__ctl__have_winSen']=['false']

            if sensor == 'CO2':
                if sensor in vavSensors:
                    MODIF_GRID[model]['VAVBox_1__ctl__have_CO2Sen']=['true']
                else:
                    MODIF_GRID[model]['VAVBox_1__ctl__have_CO2Sen']=['false']
                    
        if reheat:
            if electriReheatCoil:
                MODIF_GRID[model]['VAVBox_1__redeclare__coiHea'] = ['Buildings.Templates.Components.Coils.ElectricHeating']
            else:
                ## TODO: how to check two way v/s three way
                MODIF_GRID[model]['VAVBox_1__redeclare__coiHea'] = ['Buildings.Templates.Components.Coils.WaterBasedHeating(typVal=Buildings.Templates.Components.Types.Valve.TwoWayModulating)']
        
        tool = 'dymola'

        all_experiment_attributes = dict(
            zip(MODELS, map(get_experiment_attributes, MODELS))
        )
        combinations = generate_combinations(models=MODELS, modif_grid=MODIF_GRID)

        EXCLUDE = None
        REMOVE_MODIF = None

        # Prune class modifications.
        combinations = prune_modifications(
            combinations=combinations,
            exclude=EXCLUDE,
            remove_modif=REMOVE_MODIF,
            fraction_test_coverage=1,
        )

        if len(combinations) == 1:
            combination = combinations[0]
            model = combination[0]
            if 'VAVBoxReheat' in model:
                vavClass = 'Buildings.Templates.ZoneEquipment.VAVReheat'
            else:
                vavClass = 'Buildings.Templates.ZoneEquipment.VAVCoolingOnly'
            
            modifications = combination[1]
            comma = ''
            heaCoiRedeclaration = ''
            for mod in modifications:
                modType = mod.split('VAVBox_1(')[1][:-1]
                if modType.startswith('ctl'):
                    controlMod = modType.split('have_')[1][:-1]
                    flag = controlMod.split('=')[1]
                    for sensor in ['occ', 'win', 'CO2']:
                        if controlMod.startswith(sensor):
                            if sensor == 'occ':
                                occSensorFlag = flag
                            if sensor == 'win':
                                winSensorFlag = flag
                            if sensor == 'CO2':
                                co2SensorFlag = flag
                elif 'coiHea' in modType:
                    comma = ','
                    idxOfOpeningParanthesis = mod.index('(')
                    idxOfClosingParanthesis = mod.rindex(')')
                    heaCoiRedeclaration = mod[idxOfOpeningParanthesis+1:idxOfClosingParanthesis]
            content = vavTemplate.render(
                packageName=packageName,
                vavName=vavName,
                vavClass=vavClass,
                occSensorFlag=occSensorFlag,
                winSensorFlag=winSensorFlag,
                co2SensorFlag=co2SensorFlag,
                comma=comma,
                heaCoiRedeclaration=heaCoiRedeclaration
            )
            print("creating modelica model for vav: {0}".format(vav))
            with open(os.path.join(packageName, vavName+'.mo'), 'w') as fp:
              fp.write(content)
