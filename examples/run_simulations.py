#!/usr/bin/env python3
#
# Run the script from obc/examples/.
#   A subdirectory with the name referenced with the variable
#   `CASE_STUDY_DIR` below must exist under obc/examples/.
#   and it must contain a `cases.py` file.
#
#############################################################
import os
import getpass
import git
import multiprocessing
import shutil
import subprocess
import sys
import tempfile
from git import Repo
from multiprocessing import Pool
from pathlib import Path

CASE_STUDY_DIR = 'case_study_1_oct_light'

BRANCH = 'case_study_1_oct_light'
MBL_PATH = os.environ['MBL']  # For working with local repo.
GIT_URL = 'https://github.com/lbl-srg/modelica-buildings'  # For working with remote repo.
ONLY_SHORT_TIME = False
FROM_GIT_HUB = True
USE_OPTIMICA = True
TOLERANCE = 1E-6
# For a result file indeed limited to NCP points, set:
#   opts['CVode_options']['store_event_points'] = False
# Currently, this requires a local modification of OCT template in buildingspy.
NCP = None  # Default 500.
LIST_VARIABLES = [  # Used for OCT simulation to reduce mat file size: use [] for no filter.
    '*conAHU*',
    '*conVAV*',
    '*yVal',
    '*y_actual',
    '*Set',
    '*_nominal',
    '*weaBus*',
    'flo.*.air.vol.T',
    'fanSup.y',
    'fanSup.port*',
    'fanSup.m_flow',
    'fanSup.dp*',
    'fanSup.P',
    'eco.port_Out.m_flow',
    'ATot',
    'flo.hRoo'
    'eco.yOut',
    'eco.yRet',
    'eco.yExh',
    'res.*',
    'flo.*.heaPorAir.T',
    'conTSup.y*',
    'conEco.swiOA.y',
    'VOut1.V_flow',
    'senSupFlo.V_flow',
    'dpDisSupFan.p_rel',
    'TSup.T',
    'TMix.T',
    'TRet.T',
    '*m1_flow',
    '*m2_flow',
    '*Q1_flow',
    '*Q2_flow',
]

if USE_OPTIMICA:
    from buildingspy.simulate.Optimica import Simulator
else:
    from buildingspy.simulate.Dymola import Simulator


def sh(cmd, path):
    ''' Run the command ```cmd``` command in the directory ```path```
    '''

#    if args.verbose:
#        print("*** " + path + "> " + '%s' % ' '.join(map(str, cmd)))
    p = subprocess.Popen(cmd, cwd=path)
    p.communicate()
    if p.returncode != 0:
        print("Error: %s." % p.returncode)
        sys.exit(p.returncode)

def create_working_directory():
    ''' Create working directory
    '''

    worDir = tempfile.mkdtemp( prefix='tmp-simulator-case_study-' + getpass.getuser() )
#    print("Created directory {}".format(worDir))
    return worDir


def clone_repository(working_directory, from_git_hub):
    '''Clone or copy repository to working directory'''
    if from_git_hub:
        print(f'*** Cloning repository {GIT_URL}')
        git.Repo.clone_from(GIT_URL, working_directory)
    else:
        shutil.rmtree(working_directory)
        print(f'*** Copying repository from {MBL_PATH} to {working_directory}')
        shutil.copytree(MBL_PATH, working_directory)


def checkout_branch(working_directory, branch):
    '''Checkout feature branch'''
    d = {}
    print(f'Checking out branch {branch}')
    r = git.Repo(working_directory)
    g = git.Git(working_directory)
    g.stash()
    g.checkout(branch)
    # Print commit
    d['branch'] = branch
    d['commit'] = str(r.active_branch.commit)

    return d


# def checkout_repository(working_directory, from_git_hub):
#     d = {}
#     if from_git_hub:
#         print("Checking out repository branch {}".format(BRANCH))
#         git_url = "https://github.com/lbl-srg/modelica-buildings"
#         r = Repo.clone_from(git_url, working_directory)
#         g = git.Git(working_directory)
#         g.checkout(BRANCH)
#         # Print commit
#         d['branch'] = BRANCH
#         d['commit'] = str(r.active_branch.commit)
#     else:
#         # This is a hack to get the local copy of the repository
#         des = os.path.join(working_directory, "Buildings")
#         print("*** Copying Buildings library to {}".format(des))
#         shutil.copytree(f"{os.environ['MBL']}/Buildings", des)
#     return d


def _simulate(spec):
    if not spec["simulate"]:
        return

    wor_dir = create_working_directory()

    out_dir = os.path.join(wor_dir, "simulations", spec["name"])
    os.makedirs(out_dir)

    # Update MODELICAPATH to get the right library version
    os.environ["MODELICAPATH"] = ":".join([spec['lib_dir'], out_dir])

    # Write git information if the simulation is based on a github checkout
    if 'git' in spec:
        with open(os.path.join(out_dir, "version.txt"), "w+") as text_file:
            text_file.write("branch={}\n".format(spec['git']['branch']))
            text_file.write("commit={}\n".format(spec['git']['commit']))

    if USE_OPTIMICA:
        s=Simulator(spec["model"], outputDirectory=out_dir)
        s.setResultFilter(LIST_VARIABLES)
    else:
        s=Simulator(spec["model"], outputDirectory=out_dir)
        s.addPreProcessingStatement("OutputCPUtime:= true;")
        s.addPreProcessingStatement("Advanced.ParallelizeCode = false;")
        s.addPreProcessingStatement("Hidden.AvoidDoubleComputation=true;")
        s.addPreProcessingStatement("Advanced.EfficientMinorEvents = true;")
    if NCP is not None:
        s.setNumberOfIntervals(NCP)

    if not 'solver' in spec:
        s.setSolver("CVode")
    if 'parameters' in spec:
        s.addParameters(spec['parameters'])
    s.setStartTime(spec["start_time"])
    s.setStopTime(spec["stop_time"])
    s.setTolerance(TOLERANCE)
#    s.showGUI(False)
    print("Starting simulation in {}".format(out_dir))
    s.simulate()

    # Copy results back
    res_des = os.path.abspath(os.path.join("simulations", spec["name"]))
    os.makedirs(Path(res_des).parent, exist_ok=True)  # Create parent directory.
    if os.path.isdir(res_des):  # Unlink destination path if it does exist.
        shutil.rmtree(res_des)
    print("Copying results to {}".format(res_des))
    shutil.move(out_dir, res_des)

    # Delete the working directory
    shutil.rmtree(wor_dir)

################################################################################
if __name__=='__main__':
    sys.path.append(CASE_STUDY_DIR)
    import cases

    # cd to case study directory.
    CWD = os.curdir
    os.chdir(CASE_STUDY_DIR)

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
    clone_repository(lib_dir, from_git_hub=FROM_GIT_HUB)
    d = checkout_branch(lib_dir, branch=BRANCH)
    # Add the directory where the library has been checked out
    for case in list_of_cases:
        case['lib_dir'] = lib_dir
        case['git'] = d

    # Run all cases
    po.map(_simulate, list_of_cases)

    # Close the pool and wait for each running task to complete.
    po.close()
    po.join()

    # Delete the checked out repository
    shutil.rmtree(lib_dir)

    # cd back to original directory.
    os.chdir(CWD)
