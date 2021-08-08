def get_cases():
    ''' Return the simulation cases that are used for the case study.

        The cases are stored in this function as they are used
        for the simulation and for the post processing.
    '''
    import copy

    cases = list()

    
    # summer time
    cases.append( \
        {'model': "ChillerPlant.ClosedLoopBase.OneDeviceWithWSE",
         "name": "base_summer",
         "long_name": "Base-case, Summer",
         "season" : "summer",
         "n_output_intervals" : 27360,
         "num_id": 0,
         "start_time": 170*24*3600,
         "stop_time":  265*24*3600})

    cases.append( \
        {'model': "ChillerPlant.ClosedLoopAlternative.OneDeviceWithWSE",
         "name": "alt_summer",
         "long_name": "Alternative, Summer",
         "season" : "summer",
         "n_output_intervals" : 27360,
         "num_id":1,
         "start_time": 170*24*3600,
         "stop_time":  265*24*3600})

    # # Modify any parameters in all cases (works w dymola)
    # for ele in cases:
    #     # switch between 27 and 21 to assess sensitivity
    #     ele['parameters'] = {'TZonSupSet': 273.15 + 21}


    # annual
    cases.append( \
        {'model': "ChillerPlant.ClosedLoopBase.OneDeviceWithWSE",
         "name": "base_annual",
         "long_name": "Base-case, Annual",
         "season" : "annual",
         "n_output_intervals" : 105120,
         "num_id": 2,
         "start_time": 0,
         "stop_time":  365*24*3600})

    cases.append( \
        {'model': "ChillerPlant.ClosedLoopAlternative.OneDeviceWithWSE",
         "name": "alt_annual",
         "long_name": "Alternative, Annual",
         "season" : "annual",
         "n_output_intervals" : 105120,
         "num_id": 3,
         "start_time": 0,
         "stop_time":  365*24*3600})

    # zone air set-point temeprature sensitivity analysis

    # + 2 degC (29 degC)

    # summer time
    cases.append( \
        {'model': "ChillerPlant.ClosedLoopBase.OneDeviceWithWSE",
         "name": "base_summer_plus_two",
         "long_name": "Base-case, +2 Zone Set, Summer",
         "season" : "summer",
         "n_output_intervals" : 27360,
         "num_id": 4,
         "start_time": 170*24*3600,
         "stop_time":  265*24*3600,
         "parameters": {'TZonSupSet': 302.15,
                        'chilledWaterReset.linPieTwo.y20': 297.15}})

    cases.append( \
        {'model': "ChillerPlant.ClosedLoopAlternative.OneDeviceWithWSE",
         "name": "alt_summer_plus_two",
         "long_name": "Alternative, +2 Zone Set, Summer",
         "season" : "summer",
         "n_output_intervals" : 27360,
         "num_id":5,
         "start_time": 170*24*3600,
         "stop_time":  265*24*3600,
         "parameters": {'TZonSupSet': 302.15,
                        'chilledWaterReset.TChiWatSupMax': 297.15}})
    
    # annual
    cases.append( \
        {'model': "ChillerPlant.ClosedLoopBase.OneDeviceWithWSE",
         "name": "base_annual_plus_two",
         "long_name": "Base-case, +2 Zone Set, Annual",
         "season" : "annual",
         "n_output_intervals" : 105120,
         "num_id": 6,
         "start_time": 0,
         "stop_time":  365*24*3600,
         "parameters": {'TZonSupSet': 302.15,
                        'chilledWaterReset.linPieTwo.y20': 297.15}})


    cases.append( \
        {'model': "ChillerPlant.ClosedLoopAlternative.OneDeviceWithWSE",
         "name": "alt_annual_plus_two",
         "long_name": "Alternative, +2 Zone Set, Annual",
         "season" : "annual",
         "n_output_intervals" : 105120,
         "num_id": 7,
         "start_time": 0,
         "stop_time":  365*24*3600,
         "parameters": {'TZonSupSet': 302.15,
                        'chilledWaterReset.TChiWatSupMax': 297.15}})


    # - 2 degC (25 degC), and - 2 degC in maximum chilled water supply

    # summer time
    cases.append( \
        {'model': "ChillerPlant.ClosedLoopBase.OneDeviceWithWSE",
         "name": "base_summer_less_two",
         "long_name": "Base-case, -2 Zone Set, Summer",
         "season" : "summer",
         "n_output_intervals" : 27360,
         "num_id": 8,
         "start_time": 170*24*3600, 
         "stop_time":  265*24*3600,
         "parameters": {'TZonSupSet': 298.15,
                        'chilledWaterReset.linPieTwo.y20': 293.15}})

    cases.append( \
        {'model': "ChillerPlant.ClosedLoopAlternative.OneDeviceWithWSE",
         "name": "alt_summer_less_two",
         "long_name": "Alternative, -2 Zone Set, Summer",
         "season" : "summer",
         "n_output_intervals" : 27360,
         "num_id":9,
         "start_time": 170*24*3600,
         "stop_time":  265*24*3600,
         "parameters": {'TZonSupSet': 298.15,
                        'chilledWaterReset.TChiWatSupMax': 293.15}})
    
    # annual
    cases.append( \
        {'model': "ChillerPlant.ClosedLoopBase.OneDeviceWithWSE",
         "name": "base_annual_less_two",
         "long_name": "Base-case, -2 Zone Set, Annual",
         "season" : "annual",
         "n_output_intervals" : 105120,
         "num_id": 10,
         "start_time": 0,
         "stop_time":  365*24*3600,
         "parameters": {'TZonSupSet': 298.15,
                        'chilledWaterReset.linPieTwo.y20': 293.15}})

    cases.append( \
        {'model': "ChillerPlant.ClosedLoopAlternative.OneDeviceWithWSE",
         "name": "alt_annual_less_two",
         "long_name": "Alternative, -2 Zone Set, Annual",
         "season" : "annual",
         "n_output_intervals" : 105120,
         "num_id": 11,
         "start_time": 0,
         "stop_time":  365*24*3600,
         "parameters": {'TZonSupSet': 298.15,
                        'chilledWaterReset.TChiWatSupMax': 293.15}})


    # wse limit test with near-stationary ramp
    cases.append( \
        {'model': "ChillerPlant.ClosedLoopBase.OneDeviceWithWSE_wse_design_limit",
         "name": "base_wse_limit",
         "long_name": "Base-case, WSE Limit Test",
         "season" : "annual",
         "n_output_intervals" : 1000,
         "num_id": 12,
         "start_time": 0,
         "stop_time":  300000,
         "parameters": {'TwtBulDes.height': 15}})

    cases.append( \
        {'model': "ChillerPlant.ClosedLoopAlternative.OneDeviceWithWSE_wse_design_limit",
         "name": "alt_wse_limit",
         "long_name": "Alternative, WSE Limit Test",
         "season" : "annual",
         "n_output_intervals" : 1000,
         "num_id": 13,
         "start_time": 0,
         "stop_time":  300000,
         "parameters": {'TwtBulDes.height': 15}})

    cases.append( \
        {'model': "ChillerPlant.ClosedLoopBase.OneDeviceWithWSE_wse_design_limit",
         "name": "base_below_wse_limit",
         "long_name": "Base-case, Below WSE Limit Test",
         "season" : "annual",
         "n_output_intervals" : 1000,
         "num_id": 14,
         "start_time": 0,
         "stop_time":  300000,
         "parameters": {'TwtBulDes.height': 12.}})

    cases.append( \
        {'model': "ChillerPlant.ClosedLoopAlternative.OneDeviceWithWSE_wse_design_limit",
         "name": "alt_below_wse_limit",
         "long_name": "Alternative, Below WSE Limit Test",
         "season" : "annual",
         "n_output_intervals" : 1000,
         "num_id": 15,
         "start_time": 0,
         "stop_time":  300000,
         "parameters": {'TwtBulDes.height': 11.5}})


    # # Add load diversity
    # cases_load_diversity = copy.deepcopy(cases)
    # for ele in cases_load_diversity:
    #     ele['name'] = "{}_diverse_loads".format(ele["name"])
    #     ele['parameters'] = {'flo.kIntNor': 0.5}

    # cases = cases + cases_load_diversity

    # # Freeze protection disabled
    # cases.append( \
    #     {'model': "VAVMultiZone.Example.FreezeProtection",
    #      "name": "winterCold_g36_freezeControl_no",
    #      "start_time": 0,
    #      "stop_time":  14*24*3600,
    #      "parameters": {'conAHU.use_TMix': False}})
    # cases.append( \
    #     {'model': "VAVMultiZone.Example.FreezeProtection",
    #      "name": "winterCold_g36_freezeControl_with",
    #      "start_time": 0,
    #      "stop_time":  14*24*3600,
    #      "parameters": {'conAHU.use_TMix': True}})

    return cases

def get_case(name):
    ''' Return the case with the specified `name`
    '''
    for c in get_cases():
        if c['name'] == name:
            return c
    raise(ValueError('Did not find case {}'.format(name)))

def get_result_fullpath(name, simulator):
    ''' Return the result file name
    '''
    if simulator not in ["dymola", "optimica"]:
        raise Exception("Unsupported simulator provided.")

    import os.path

    case = get_case(name)
    
    mat_name = False

    for file in os.listdir(
        os.path.join("simulations", simulator, name)):
        if '.mat' in file:
            mat_name = file
        
    if not mat_name:
        raise Exception("No *.mat file found.")

    return os.path.join("simulations", simulator, name, mat_name)

def get_list_of_case_names():
    '''Return a list of all case names
    '''
    names = list()
    for c in get_cases():
        names.append(c["name"])

    return names
