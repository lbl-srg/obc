def get_cases():
    ''' Return the simulation cases that are used for the case study.

        The cases are stored in this function as they are used
        for the simulation and for the post processing.
    '''
    import copy

    cases = list()
    
    # # summer time
    # cases.append( \
    #     {'model': "ChillerPlant.ClosedLoopBase.OneDeviceWithWSE",
    #      "name": "base_summer",
    #      "long_name": "Base-case, Summer",
    #      "season" : "summer",
    #      "n_output_intervals" : 10800,
    #      "num_id":0,
    #      "start_time": 170*24*3600,
    #      "stop_time":  265*24*3600})

    cases.append( \
        {'model': "ChillerPlant.ClosedLoopBase.OneDeviceWithWSE_DedicatedCWLoops_w_HeadPressure",
         "name": "base_2loop_summer",
         "long_name": "Base-case w 2 CW loops, Summer",
         "season" : "summer",
         "n_output_intervals" : 10800,
         "num_id":0,
         "start_time": 170*24*3600,
         "stop_time":  265*24*3600})

    # cases.append( \
    #     {'model': "ChillerPlant.ClosedLoop1711.OneDeviceWithWSE_HeaPreVal",
    #      "name": "1711_heapreval_summer",
    #      "long_name": "Adds head pressure valve modulation, Summer",
    #      "season" : "summer",
    #      "n_output_intervals" : 10800,
    #      "num_id":1,
    #      "start_time": 170*24*3600,
    #      "stop_time":  265*24*3600})

    # cases.append( \
    #     {'model': "ChillerPlant.ClosedLoop1711.OneDeviceWithWSE_WSEOnOff",
    #      "name": "1711_wse_summer",
    #      "long_name": "Uses alternative WSE on/off, Summer",
    #      "season" : "summer",
    #      "n_output_intervals" : 10800,
    #      "num_id":2,
    #      "start_time": 170*24*3600,
    #      "stop_time":  265*24*3600})

    # cases.append( \
    #     {'model': "ChillerPlant.ClosedLoop1711.OneDeviceWithWSE_HeaPreValAndWSEOnOff",
    #      "name": "1711_heapreval_wse_summer",
    #      "long_name": "Adds head pressure valve modulation and uses alternative WSE on/off, Summer",
    #      "season" : "summer",
    #      "n_output_intervals" : 10800,
    #      "num_id":3,
    #      "start_time": 170*24*3600,
    #      "stop_time":  265*24*3600})

    # cases.append( \
    #     {'model': "ChillerPlant.ClosedLoop1711.OneDeviceWithWSE_HeaPreValAndWSEOnOffAndStaging",
    #      "name": "1711_heapreval_wse_sta_summer",
    #      "long_name": "Head pressure valve modulation, alternative WSE on/off and staging, Summer",
    #      "season" : "summer",
    #      "n_output_intervals" : 10800,
    #      "num_id":4,
    #      "start_time": 170*24*3600,
    #      "stop_time":  265*24*3600})

    # cases.append( \
    #     {'model': "ChillerPlant.ClosedLoop1711.OneDeviceWithWSE",
    #      "name": "1711_all_summer",
    #      "long_name": "Alternative, Summer",
    #      "season" : "summer",
    #      "n_output_intervals" : 10800,
    #      "num_id":5,
    #      "start_time": 170*24*3600,
    #      "stop_time":  265*24*3600})

    # # annual
    # cases.append( \
    #     {'model': "ChillerPlant.ClosedLoopBase.OneDeviceWithWSE",
    #      "name": "base_annual",
    #      "long_name": "Base-case, Annual",
    #      "season" : "annual",
    #      "n_output_intervals" : 10800,
    #      "num_id":6,
    #      "start_time": 0,
    #      "stop_time":  365*24*3600})

    cases.append( \
        {'model': "ChillerPlant.ClosedLoopBase.OneDeviceWithWSE_DedicatedCWLoops_w_HeadPressure",
         "name": "base_2loop_annual",
         "long_name": "Base-case w 2 CW loops, Annual",
         "season" : "annual",
         "n_output_intervals" : 10800,
         "num_id":0,
         "start_time": 0,
         "stop_time":  365*24*3600})

    # cases.append( \
    #     {'model': "ChillerPlant.ClosedLoop1711.OneDeviceWithWSE_HeaPreVal",
    #      "name": "1711_heapreval_annual",
    #      "long_name": "Adds head pressure valve modulation, Annual",
    #      "season" : "annual",
    #      "n_output_intervals" : 10800,
    #      "num_id":7,
    #      "start_time": 0,
    #      "stop_time":  365*24*3600})

    # cases.append( \
    #     {'model': "ChillerPlant.ClosedLoop1711.OneDeviceWithWSE_WSEOnOff",
    #      "name": "1711_wse_annual",
    #      "long_name": "Uses alternative WSE on/off, Annual",
    #      "season" : "annual",
    #      "n_output_intervals" : 10800,
    #      "num_id":8,
    #      "start_time": 0,
    #      "stop_time":  365*24*3600})

    # cases.append( \
    #     {'model': "ChillerPlant.ClosedLoop1711.OneDeviceWithWSE_HeaPreValAndWSEOnOff",
    #      "name": "1711_heapreval_wse_annual",
    #      "long_name": "Adds head pressure valve modulation and uses alternative WSE on/off, Annual",
    #      "season" : "annual",
    #      "n_output_intervals" : 10800,
    #      "num_id":9,
    #      "start_time": 0,
    #      "stop_time":  365*24*3600})

    # cases.append( \
    #     {'model': "ChillerPlant.ClosedLoop1711.OneDeviceWithWSE_HeaPreValAndWSEOnOffAndStaging",
    #      "name": "1711_heapreval_wse_sta_annual",
    #      "long_name": "Head pressure valve modulation, alternative WSE on/off and staging, Annual",
    #      "season" : "annual",
    #      "n_output_intervals" : 10800,
    #      "num_id":10,
    #      "start_time": 0,
    #      "stop_time":  365*24*3600})

    # cases.append( \
    #     {'model': "ChillerPlant.ClosedLoop1711.OneDeviceWithWSE",
    #      "name": "1711_all_annual",
    #      "long_name": "Alternative, Annual",
    #      "season" : "annual",
    #      "n_output_intervals" : 10800,
    #      "num_id":11,
    #      "start_time": 0,
    #      "stop_time":  365*24*3600})

    # # Modify any parameters in all cases (works w dymola)
    # for ele in cases:
    #     # switch between 27 and 21 to assess sensitivity
    #     ele['parameters'] = {'TZonSupSet': 273.15 + 21}


    # # annual
    # cases.append( \
    #     {'model': "ChillerPlant.ClosedLoopBase.OneDeviceWithWSE",
    #      "name": "base_annual",
    #      "long_name": "Base-case",
    #      "season" : "annual",
    #      "num_id":0,
    #      "start_time": 0,
    #      "stop_time":  365*24*3600})

    # cases.append( \
    #     {'model': "ChillerPlant.ClosedLoop1711.OneDeviceWithWSE_HeaPreVal",
    #      "name": "1711_annual",
    #      "long_name": "Alternative sub-controller: CW reset",
    #      "season" : "annual",
    #      "num_id":1,
    #      "start_time": 0,
    #      "stop_time":  365*24*3600})

    # cases.append( \
    #     {'model': "ChillerPlant.ClosedLoop1711.OneDeviceWithWSE_HeaPreVal",
    #      "name": "1711_annual",
    #      "long_name": "Alternative sub-controller: WSE on/off",
    #      "season" : "annual",
    #      "num_id":2,
    #      "start_time": 0,
    #      "stop_time":  365*24*3600})

    # cases.append( \
    #     {'model': "ChillerPlant.ClosedLoop1711.OneDeviceWithWSE_HeaPreVal",
    #      "name": "1711_annual",
    #      "long_name": "Alternative sub-controller: CW reset and WSE on/off",
    #      "season" : "annual",
    #      "num_id":3,
    #      "start_time": 0,
    #      "stop_time":  365*24*3600})


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
