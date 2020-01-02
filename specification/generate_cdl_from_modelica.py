#!/usr/bin/python3
import tempfile
import re
import glob, os
import shutil
import fnmatch


REPO="git@github.com:lbl-srg/modelica-buildings.git"
BASE_BRANCH="master"

html_output_dir = os.path.join("build", "html", "cdl", "latest")

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

def run_simulation(worDir, cmd):
    ''' Run the simulation.

    :param worDir: The working directory.
    :param cmd: An array which is passed to the `args` argument of
                :mod:`subprocess.Popen`

    .. note:: This method is outside the class definition to
              allow parallel computing.
    '''

    import subprocess

    logFilNam=os.path.join(worDir, 'stdout.log')
    logFil = open(logFilNam, 'w')
    pro = subprocess.Popen(args=cmd,
                           stdout=logFil,
                           stderr=logFil,
                           shell=False,
                           cwd=worDir)
    try:
        retcode = pro.wait()

        logFil.close()
        if retcode != 0:
            print("Child was terminated by signal {}".format(retcode))
            return retcode
        else:
            return 0
    except OSError as e:
        sys.stderr.write("Execution of '" + " ".join(map(str, cmd)) + " failed.\n" +
                         "Working directory is '" + worDir + "'.")
        raise(e)
    except KeyboardInterrupt as e:
        pro.kill()
        sys.stderr.write("Users stopped simulation in %s.\n" % worDir)



TMP=tempfile.mkdtemp(prefix="tmp-cdl-")
print("----- {}".format(TMP))
# Check out the latest version of the Buildings library that has the CDL implementation
# Get a fresh clone
sh(cmd = ['git', 'clone', "--single-branch", '-b', BASE_BRANCH, REPO], path = TMP)


shutil.copytree(os.path.join(TMP, "modelica-buildings", "Buildings", "Controls", "OBC", "CDL"), \
                os.path.join(TMP, "CDL"))
shutil.copytree(os.path.join(TMP, "modelica-buildings", "Buildings", "Resources", "Images", "Controls", "OBC", "CDL"), \
                os.path.join(TMP, "CDL", "Resources", "Images"))
shutil.copytree(os.path.join(TMP, "modelica-buildings", "Buildings", "Resources", "www"), \
                os.path.join(TMP, "CDL", "Resources", "www"))


# Fix the .mo files
for root, dirnames, filenames in os.walk(os.path.join(TMP, "CDL")):
    matches = []
    for filename in fnmatch.filter(filenames, '*.mo'):
        matches.append(os.path.join(root, filename))
        for fil in matches:
            lines = []
            with open(fil, 'r') as infile:
                for line in infile:
                    # This fixes wrong formatting for the use cases
                    line = re.sub(r'Buildings.Controls.OBC\.*', '', line)
                    # Update link to images
                    line = line.replace('Buildings/Resources/Images/Controls/OBC/CDL', \
                                        'CDL/Resources/Images')
                    lines.append(line)

            with open(fil, 'w') as outfile:
                for line in lines:
                    outfile.write(line)


# Export html
with open(os.path.join(TMP, "CDL", "export.mos"), 'w') as outfile:
    outfile.write("openModel(\"package.mo\");\n")
#    outfile.write("exportHTMLDirectory(name=\"CDL\");\n")
#    outfile.write("exit")

run_simulation(os.path.join(TMP, "CDL"), \
               ["dymola", "export.mos"])

# Add css file
sh(cmd = [os.path.join("..", "modelica-buildings", "bin", "cleanHTML.py"), \
          "--library", "CDL", "--homepage", "http://obc.lbl.gov/specification"], \
   path = os.path.join(TMP, "CDL"))

if os.path.exists(html_output_dir):
    shutil.rmtree(html_output_dir)
# Copy generated files from tmp directory
shutil.copytree(os.path.join(TMP, "CDL", "help"), os.path.join(html_output_dir, "help"))
shutil.copytree(os.path.join(TMP, "CDL", "Resources", "www"), os.path.join(html_output_dir, "Resources", "www"))
shutil.copytree(os.path.join(TMP, "CDL", "Resources", "Images"), os.path.join(html_output_dir, "Resources", "Images"))

# Move image with logo
shutil.copy2(os.path.join("source", "_static", "obc-logo.png"), os.path.join(html_output_dir, "Resources", "www", "library-logo.png"))

print("HTML documentation is in {}".format(html_output_dir))
