#!/usr/bin/env python
#
# Start the script from the directory that contains the package
# with your model
#############################################################
import os
# MBL branch
BRANCH="issue2330_images"
ONLY_SHORT_TIME=False
FROM_GIT_HUB = False
USE_OPTIMICA = True

if USE_OPTIMICA:
    sim_engine = "optimica"
else:
    sim_engine = "dymola"


CASE_STUDY_PACKAGE = "ChillerPlant"

from pdb import set_trace as bp


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

def checkout_repository(working_directory, from_git_hub):
    import os
    from git import Repo
    import git
    d = {}
    if from_git_hub:
        print("Checking out repository branch {}".format(BRANCH))
        git_url = "https://github.com/lbl-srg/modelica-buildings"
        r = Repo.clone_from(git_url, working_directory)
        g = git.Git(working_directory)
        g.checkout(BRANCH)
        # Print commit
        d['branch'] = BRANCH
        d['commit'] = str(r.active_branch.commit)
    else:
        # This is a hack to get the local copy of the repository
        des = os.path.join(working_directory, "Buildings")
        print("*** Copying Buildings library to {}".format(des))
        shutil.copytree("/home/milicag/repos/modelica-buildings/Buildings", des)
    return d

def _simulate(spec):
    import os
    if USE_OPTIMICA:
        from buildingspy.simulate.Optimica import Simulator
    else:
        from buildingspy.simulate.Dymola import Simulator

    if not spec["simulate"]:
        return

    wor_dir = create_working_directory()

    out_dir = os.path.join(wor_dir, "simulations", sim_engine, spec["name"])
    os.makedirs(out_dir)

    # Update MODELICAPATH to get the right library version
    os.environ["MODELICAPATH"] = ":".join([spec['lib_dir'], out_dir])

    # Copy the models
#    print("Copying models from {} to {}".format(CWD, wor_dir))
    shutil.copytree(os.path.join(CWD, CASE_STUDY_PACKAGE), os.path.join(wor_dir, CASE_STUDY_PACKAGE))
    # Change the working directory so that the right checkout is loaded
    os.chdir(os.path.join(wor_dir))

    # Write git information if the simulation is based on a github checkout
    if 'git' in spec:
        with open(os.path.join(out_dir, "version.txt"), "w+") as text_file:
            text_file.write("branch={}\n".format(spec['git']['branch']))
            text_file.write("commit={}\n".format(spec['git']['commit']))

   # s=Simulator(spec["model"], "dymola", outputDirectory=out_dir)
    s=Simulator(spec["model"], outputDirectory=out_dir)
    if not USE_OPTIMICA:
        s.addPreProcessingStatement("OutputCPUtime:= true;")
        s.addPreProcessingStatement("Advanced.ParallelizeCode = false;")
        # s.addPreProcessingStatement("Advanced.EfficientMinorEvents = true;")
    if not 'solver' in spec:
        if USE_OPTIMICA:
            s.setSolver("CVode")
        else:
            s.setSolver("Cvode")
    if 'parameters' in spec:
        s.addParameters(spec['parameters'])
    s.setStartTime(spec["start_time"])
    s.setStopTime(spec["stop_time"])
    s.setNumberOfIntervals(spec["n_output_intervals"])
    s.setTolerance(1E-5)
    if not USE_OPTIMICA:
        s.showGUI(False)
    print("Starting simulation in {}".format(out_dir))
    s.simulate()

    # Copy results back
    res_des = os.path.join(CWD, "simulations", sim_engine, spec["name"])
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
    d = checkout_repository(lib_dir, from_git_hub = FROM_GIT_HUB)
    # Add the directory where the library has been checked out
    for case in list_of_cases:
        case['lib_dir'] = lib_dir
        if FROM_GIT_HUB:
            case['git'] = d

        # _simulate(case)

    # Run all cases

    # bp()
    po.map(_simulate, list_of_cases)
        
    # Delete the checked out repository
    shutil.rmtree(lib_dir)
