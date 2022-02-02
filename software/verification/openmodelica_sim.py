import subprocess
import os
import shutil

def run_process(return_dict, cmd, worDir, timeout):
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
    return

def translate(model, timeout=500, solver='dassl', stop_time=86400):
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
translated := translateModel({0}, method="{1}", stopTime={2});
getErrorString();
                
if translated then
  retVal := system("make -f {3}.makefile");
else
  print("Translation failed.");
  retVal := 10;
end if;
exit(retVal);
""".format(model, solver, stop_time, model))

        # Translate and compile model
        cmd = ["omc", scr_nam]
        return_dict['cmd'] = ' '.join(cmd)
        run_process(return_dict, cmd, worDir, timeout)
    except Exception as e:
        raise Exception("translation failed; error={}".format(e))
    return return_dict

def simulate(model, timeout=500, solver='dassl'):
    return_dict = {}

    try:
        worDir = "{{ working_directory }}"
        scr_nam = "{0}_simulate.mos".format(model)
        with open(scr_nam, 'w') as f:
            f.write("""retVal := system("./{0} -s {1}  -steps -cpu -lv LOG_STATS");
exit(retVal);
""".format(model, solver))
        cmd = ["omc", scr_nam]
        return_dict['cmd'] = ' '.join(cmd)
        run_process(return_dict, cmd, worDir, timeout)
    except Exception as e:
        raise Exception("simulation failed; error={}".format(e))
    return return_dict


def delete_files(model):
    model = "{}".format(model)
    for fp in os.listdir('.'):
        if fp.startswith(model):
            os.remove(fp)

def execute_omc(model, output_folder):
    translate(model)
    simulate(model)
    shutil.move("{}_res.mat".format(model), os.path.join(output_folder, "{}_res.mat".format(model)))
    delete_files(model)
