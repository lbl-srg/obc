def get_cases():
    ''' Return the simulation cases that are used for the case study.

        The cases are stored in this function as they are used
        for the simulation and for the post processing.
    '''
    import copy

    cases = list()
#    cases.append( \
#        {'model': "Buildings.Examples.VAVReheat.Guideline36",
#         "name": "annual_g36",
#         "start_time": 0,
#         "stop_time":  365*24*3600})
#    cases.append( \
#        {'model': "Buildings.Examples.VAVReheat.Guideline36",
#         "name": "winter_g36",
#         "start_time": 0,
#         "stop_time":  14*24*3600})
#    cases.append( \
#        {'model': "Buildings.Examples.VAVReheat.Guideline36",
#         "name": "summer_g36",
#         "start_time": 190*24*3600,
#         "stop_time":  204*24*3600})
#    cases.append( \
#        {'model': "Buildings.Examples.VAVReheat.Guideline36",
#         "name": "spring_g36",
#         "start_time": 80*24*3600,
#         "stop_time":  94*24*3600})
    cases.append( \
        {'model': "Buildings.Examples.VAVReheat.Guideline36",
         "name": "winter_one_day_g36",
         "start_time": 0,
         "stop_time":  1*24*3600})
    cases.append( \
        {'model': "Buildings.Examples.VAVReheat.Guideline36",
         "name": "summer_one_day_g36",
         "start_time": 190*24*3600,
         "stop_time":  191*24*3600})

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
