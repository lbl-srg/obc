#!/usr/bin/env python
#
# Start the script for the directory that contains the package
# with your model
#############################################################
import os

ONLY_SHORT_TIME=False

CWD = os.getcwd()

def sh(cmd, path):
    ''' Run the command ```cmd``` command in the directory ```path```
    '''
    import subprocess
    import sys
#    if args.verbose:
#        print("*** " + path + "> " + '%s' % ' '.join(map(str, cmd)))
    p = subprocess.Popen(cmd, cwd = path)
    p.communicate()
    if p.returncode != 0:
        print("Error: %s." % p.returncode)
        sys.exit(p.returncode)

def create_working_directory():
    ''' Create working directory
    '''
    import os
    import tempfile
    import getpass
    worDir = tempfile.mkdtemp( prefix='tmp-simulator-case_study-' + getpass.getuser() )
#    print("Created directory {}".format(worDir))
    return worDir

def _simulate(spec):
    import os

    from buildingspy.simulate.Simulator import Simulator
    if not spec["simulate"]:
        return

    wor_dir = create_working_directory()

    out_dir = os.path.join(wor_dir, "simulations", spec["name"])
    os.makedirs(out_dir)

    # Update MODELICAPATH to get the right library version
    os.environ["MODELICAPATH"] = ":".join([spec['lib_dir'], out_dir])

    # Copy the models
#    print("Copying models from {} to {}".format(CWD, wor_dir))
    shutil.copytree(os.path.join(CWD, "SystemModel"), os.path.join(wor_dir, "SystemModel"))
    # Change the working directory so that the right checkout is loaded
    os.chdir(os.path.join(wor_dir, "SystemModel"))

    # Write git information if the simulation is based on a github checkout
    if 'git' in spec:
        with open(os.path.join(out_dir, "version.txt"), "w+") as text_file:
            text_file.write("branch={}\n".format(spec['git']['branch']))
            text_file.write("commit={}\n".format(spec['git']['commit']))

    s=Simulator(spec["model"], "dymola", outputDirectory=out_dir)
    s.addPreProcessingStatement("OutputCPUtime:= true;")
    s.addPreProcessingStatement("Advanced.ParallelizeCode = false;")
#    s.addPreProcessingStatement("Advanced.EfficientMinorEvents = true;")
    if not 'solver' in spec:
        s.setSolver("Cvode")
    if 'parameters' in spec:
        s.addParameters(spec['parameters'])
    s.setStartTime(spec["start_time"])
    s.setStopTime(spec["stop_time"])
    s.setTolerance(1E-5)
    s.showGUI(False)
    print("Starting simulation in {}".format(out_dir))
    s.simulate()

    # Copy results back
    res_des = os.path.join(CWD, "simulations", spec["name"])
    if os.path.isdir(res_des):
       shutil.rmtree(res_des)
    print("Copying results to {}".format(res_des))
    shutil.move(out_dir, res_des)

    # Delete the working directory
    shutil.rmtree(wor_dir)

################################################################################
if __name__=='__main__':
    from multiprocessing import Pool
    import multiprocessing
    import shutil
    import cases

    list_of_cases = cases.get_cases()

    for iEle in range(len(list_of_cases)):
        if ONLY_SHORT_TIME:
            if "annual" in list_of_cases[iEle]['name']:
                print("Warning: Deleting {} from list of cases.".format(list_of_cases[iEle]['name']))
                list_of_cases[iEle]['simulate'] = False
            else:
                list_of_cases[iEle]['simulate'] = True
        else:
            list_of_cases[iEle]['simulate'] = True


    # Number of parallel processes
    nPro = multiprocessing.cpu_count()
    po = Pool(nPro)

    lib_dir = create_working_directory()

    # Add the directory where the library has been checked out
    for case in list_of_cases:
        case['lib_dir'] = lib_dir

    # Run all cases
    po.map(_simulate, list_of_cases)

    # Delete the checked out repository
    shutil.rmtree(lib_dir)
