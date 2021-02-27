def get_cases():
    ''' Return the simulation cases that are used for the case study.

        The cases are stored in this function as they are used
        for the simulation and for the post processing.
    '''
    import copy

    cases = list()
    
    # short test
    cases.append( \
        {'model': "ChillerPlant.ClosedLoopBase.OneDeviceWithWSE",
         "name": "base_test",
         "long_name": "Base-case",
         "season" : "test",
         "n_output_intervals" : 100,
         "num_id":0,
         "start_time": 0,
         "stop_time":  20*24*3600})

    cases.append( \
        {'model': "ChillerPlant.ClosedLoop1711.OneDeviceWithWSE_CWReset",
         "name": "1711_cwreset_test",
         "long_name": "Alternative sub-controller: CW reset",
         "season" : "test",
         "n_output_intervals" : 100,
         "num_id":1,
         "start_time": 0,
         "stop_time":  20*24*3600})

    cases.append( \
        {'model': "ChillerPlant.ClosedLoop1711.OneDeviceWithWSE_WSEOnOff",
         "name": "1711_wse_test",
         "long_name": "Alternative sub-controller: WSE on/off",
         "season" : "test",
         "n_output_intervals" : 100,
         "num_id":2,
         "start_time": 0,
         "stop_time":  20*24*3600})

    cases.append( \
        {'model': "ChillerPlant.ClosedLoop1711.OneDeviceWithWSE_CWResetAndWSEOnOff",
         "name": "1711_cwreset_wse_test",
         "long_name": "Alternative sub-controller: CW reset and WSE on/off",
         "season" : "test",
         "n_output_intervals" : 100,
         "num_id":3,
         "start_time": 0,
         "stop_time":  20*24*3600})


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
    #     {'model': "ChillerPlant.ClosedLoop1711.OneDeviceWithWSE_CWReset",
    #      "name": "1711_annual",
    #      "long_name": "Alternative sub-controller: CW reset",
    #      "season" : "annual",
    #      "num_id":1,
    #      "start_time": 0,
    #      "stop_time":  365*24*3600})

    # cases.append( \
    #     {'model': "ChillerPlant.ClosedLoop1711.OneDeviceWithWSE_CWReset",
    #      "name": "1711_annual",
    #      "long_name": "Alternative sub-controller: WSE on/off",
    #      "season" : "annual",
    #      "num_id":2,
    #      "start_time": 0,
    #      "stop_time":  365*24*3600})

    # cases.append( \
    #     {'model': "ChillerPlant.ClosedLoop1711.OneDeviceWithWSE_CWReset",
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
    
    for file in os.listdir(
        os.path.join("simulations", simulator, name)):
        if '.mat' in file:
            mat_name = file

    return os.path.join("simulations", simulator, name, mat_name)

def get_list_of_case_names():
    '''Return a list of all case names
    '''
    names = list()
    for c in get_cases():
        names.append(c["name"])

    return names
