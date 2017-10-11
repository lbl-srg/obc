#!/usr/bin/env python
#
# Start the script for the directory that contains the package
# with your model
#############################################################
import os
BRANCH="issue967_VAVReheat_CDL"
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

def checkout_repository(working_directory):
    import os
    from git import Repo
    import git
    git_url = "https://github.com/lbl-srg/modelica-buildings"
    Repo.clone_from(git_url, working_directory)
    g = git.Git(working_directory)
    g.checkout(BRANCH)


def _simulate(spec):
    import os

    from buildingspy.simulate.Simulator import Simulator

    wor_dir = create_working_directory()

    out_dir = os.path.join(wor_dir, spec["name"])

    # Update MODELICAPATH to get the right library version
    os.environ["MODELICAPATH"] = ":".join([spec['lib_dir'], out_dir])



    # Copy the models
#    print("Copying models from {} to {}".format(CWD, wor_dir))
    shutil.copytree(os.path.join(CWD, "VAVMultiZone"), os.path.join(wor_dir, "VAVMultiZone"))
    # Change the working directory so that the right checkout is loaded
    os.chdir(os.path.join(wor_dir, "VAVMultiZone"))

    s=Simulator(spec["model"], "dymola", outputDirectory=out_dir)
    s.addPreProcessingStatement("OutputCPUtime:= true;")
    s.addPreProcessingStatement("Advanced.ParallelizeCode = false;")
    if not 'solver' in spec:
        s.setSolver("radau")
    s.setStartTime(spec["start_time"])
    s.setStopTime(spec["stop_time"])
    s.setTolerance(1E-6)
    s.showGUI(False)
    print("Starting simulation in {}".format(out_dir))
    s.simulate()

    # Copy results back
    res_des = os.path.join(CWD, spec["name"])
    if os.path.isdir(res_des):
       shutil.rmtree(res_des)
    print("Copying results to {}".format(res_des))
    shutil.move(out_dir, res_des)

    # Delete the working directory
    shutil.rmtree(wor_dir)

################################################################################
if __name__=='__main__':
    from multiprocessing import Pool
    import shutil
    import cases

    list_of_cases = cases.get_cases()

    # Number of parallel processes
    nPro = 10
    po = Pool(nPro)

    lib_dir = create_working_directory()
    checkout_repository(lib_dir)
    # Add the directory where the library has been checked out
    for case in list_of_cases:
        case['lib_dir'] = lib_dir

    # Run all cases
    po.map(_simulate, list_of_cases)
    #shutil.rmtree(lib_dir)

    # Delete the checked out repository
    shutil.rmtree(lib_dir)
