import subprocess
import os
import shutil

def run_process(return_dict, cmd, worDir, timeout):
    """Function to run a subprocess command
    Parameters:
    ----------
    return_dict: dict
            Contains information about the command
    cmd: str
            Command to be run
    worDir: str
            Current working directory for the command to run
    timeout: int
            Number of seconds before the command times out

    Returns:
    --------
    return_dict: dict
        Contains information about the command
    """

    output = subprocess.check_output(
        cmd,
        # cwd=worDir,
        # timeout=timeout,
        stderr=subprocess.STDOUT,
        shell=False)

    return_dict['success'] = True
    if 'stdout' in return_dict:
        return_dict['stdout'] += output.decode("utf-8")
    else:
        return_dict['stdout'] = output.decode("utf-8")
    return return_dict

def translate(model, timeout=500, solver='dassl'):
    """Function to generate and run a mos script to translate a model
    Parameters:
    ----------
    model: str
            Model to be translated
    timeout: int
            Number of seconds before the command times out
    solver: str
            Solver to be used for translation

    Returns:
    --------
    return_dict: dict
        Contains information about the translation process and outputs
    """
    return_dict = {}

    # Write translation script
    try:
        worDir = "{{ working_directory }}"
        scr_nam = "{0}_translate.mos".format(model)
        with open(scr_nam, 'w') as f:
            f.write("""setCommandLineOptions("-d=nogen");
setCommandLineOptions("-d=initialization");
setCommandLineOptions("-d=backenddaeinfo");
setCommandLineOptions("-d=discreteinfo");
setCommandLineOptions("-d=stateselection");
setMatchingAlgorithm("PFPlusExt");
setIndexReductionMethod("dynamicStateSelection");
loadFile("Buildings/package.mo");
translated := translateModel({0}, method="{1}");
getErrorString();

if translated then
  retVal := system("make -f {2}.makefile");
else
  print("Translation failed.");
  retVal := 10;
end if;
exit(retVal);
""".format(model, solver, model))

        # Translate and compile model
        cmd = ["omc", scr_nam]
        return_dict['cmd'] = ' '.join(cmd)
        run_process(return_dict, cmd, worDir, timeout)
    except Exception as e:
        raise Exception("translation failed; error={}".format(e))
    return return_dict

def simulate(model, timeout=500, solver='dassl', stop_time=3600):
    """Function to generate and run a mos script to simulate a model
    Parameters:
    ----------
    model: str
            Model to be simulated
    timeout: int
            Number of seconds before the command times out
    solver: str
            Solver to be used for translation

    Returns:
    --------
    return_dict: dict
        Contains information about the simulation process and outputs
    """
    return_dict = {}

    try:
        worDir = "{{ working_directory }}"
        scr_nam = "{0}_simulate.mos".format(model)
        with open(scr_nam, 'w') as f:
            f.write("""retVal := system("./{0} -s {1}  -steps -cpu -lv LOG_STATS -override=stopTime={2}");
exit(retVal);
""".format(model, solver, stop_time))
        cmd = ["omc", scr_nam]
        return_dict['cmd'] = ' '.join(cmd)
        run_process(return_dict, cmd, worDir, timeout)
    except Exception as e:
        raise Exception("simulation failed; error={}".format(e))
    return return_dict


def delete_files(model):
    """Function to remove generate files (*.c, *.h, *.o, *.intdata, *.realdata) during translation and simulation
    Parameters:
    ----------
    model: str
            Model to be translated
    """
    model = "{}".format(model)
    for fp in os.listdir('.'):
        if fp.startswith(model):
            os.remove(fp)

def execute_omc(model, output_folder):
    """Function to translate and simulate a model, producing a {model}_res.mat file and deleting other files
     Parameters:
     ----------
     model: str
            Model to be executed
    output_folder: str
            Location for generated {model}_res.mat file
     """
    translate(model)
    simulate(model)
    shutil.move("{}_res.mat".format(model), os.path.join(output_folder, "{}_res.mat".format(model)))
    delete_files(model)
