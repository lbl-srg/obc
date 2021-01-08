This case study is identical to case_study_1 except that

- It has been done with a more recent version of the Buildings
library (see the "version.txt" files). The results are significantly different from case_study_1 due to
https://github.com/lbl-srg/modelica-buildings/issues/2019
https://github.com/lbl-srg/modelica-buildings/issues/2028
https://github.com/lbl-srg/modelica-buildings/issues/2024

- The simulations were run with OCT.

Also the python code in `run_simulations.py` and `post_process.ipynb`
was refactored and those two scripts shall now be run from
the top-level `examples/.` directory.
Only `cases.py` remains under each example directory.
