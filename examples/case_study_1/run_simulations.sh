#!/usr/bin/env python
#
# Start the script for the directory that contains the package
# with your model
#############################################################
import os
BRANCH=master
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
    curDir = os.path.abspath(".")
    ds = curDir.split(os.sep)
    dirNam = ds[len(ds) - 1]
    worDir = os.path.join(tempfile.mkdtemp(
        prefix='tmp-simulator-case_study-' + getpass.getuser() + '-'), dirNam)
    return worDir

def checkout_repository(num, working_directory):
    import os
    from git import Repo
    import git
    git_url = "https://github.com/lbl-srg/modelica-buildings"
#    print("checking out to {}".format(working_directory))
    Repo.clone_from(git_url, working_directory)
    g = git.Git(working_directory)
    g.checkout(BRANCH)


def _simulate(spec):
    import os

    from buildingspy.simulate.Simulator import Simulator

    model = spec["model"]
    out_dir = spec["output_directory"]
    start_time = spec["start_time"]
    stop_time   = spec["stop_time"]
    wor_dir = create_working_directory()
    # Update MODELICAPATH to get the right library version
    os.environ["MODELICAPATH"] = ":".join([CWD, out_dir])

    checkout_repository(num, wor_dir)

    out_dir = os.path.join(wor_dir, "out_dir")
    # Change the working directory so that the right checkout is loaded
    os.chdir(wor_dir)

    s=Simulator(model, "dymola", outputDirectory=out_dir)
    s.addPreProcessingStatement("OutputCPUtime:= true;")
    s.addPreProcessingStatement("Advanced.ParallelizeCode = false;")
    s.setSolver("radau")
    s.setStartTime(start_time)
    s.setStopTime(stop_time)
    s.setTolerance(1E-6)
    s.showGUI(False)
#    print("Starting simulation")
    s.simulate()

################################################################################
if __name__=='__main__':
   from multiprocessing import Pool

   cases = list()
   cases.append( \
       {'model': "VAVMultiZone.Example.SimpleTest",
        "output_directory": "case1",
        "start_time": 0,
        "stop_time":  1}
   cases.append( \
       {'model': "VAVMultiZone.Example.SimpleTest",
        "output_directory": "case1",
        "start_time": 0,
        "stop_time":  2}

    # Number of parallel processes
    nPro = 10
    po = Pool(nPro)
    # Run all cases
    po.map(_simulate, cases)
