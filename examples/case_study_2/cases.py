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
         "num_id":0,
         "start_time": 0,
         "stop_time":  20*24*3600})

    cases.append( \
        {'model': "ChillerPlant.ClosedLoop1711.OneDeviceWithWSE_CWReset",
         "name": "1711_cwreset_test",
         "long_name": "Alternative sub-controller: CW reset",
         "season" : "test",
         "num_id":1,
         "start_time": 0,
         "stop_time":  20*24*3600})

    cases.append( \
        {'model': "ChillerPlant.ClosedLoop1711.OneDeviceWithWSE_WSEOnOff",
         "name": "1711_wse_test",
         "long_name": "Alternative sub-controller: WSE on/off",
         "season" : "test",
         "num_id":2,
         "start_time": 0,
         "stop_time":  20*24*3600})

    cases.append( \
        {'model': "ChillerPlant.ClosedLoop1711.OneDeviceWithWSE_CWResetAndWSEOnOff",
         "name": "1711_cwreset_wse_test",
         "long_name": "Alternative sub-controller: CW reset and WSE on/off",
         "season" : "test",
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

def get_result_file_name(name):
    ''' Return the result file name
    '''
    import os.path
    case = get_case(name)
    model_name = (os.path.splitext(case['model'])[1])[1:]
    mat_name = "{}.mat".format( model_name )
    return os.path.join("simulations", name, mat_name)

def get_list_of_case_names():
    '''Return a list of all case names
    '''
    names = list()
    for c in get_cases():
        names.append(c["name"])

    return names
