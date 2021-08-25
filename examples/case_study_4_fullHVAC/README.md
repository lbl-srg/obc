This directory contains the files for the case study
that has a primary and secondary HVAC system.

To check out the library files, run

>./install.sh

This will install the Buildings Library and BuildingsPy into the `tmp` directory
which is not under version control.

The models used for the case study are in `SystemModel`.

The file `cases.py` contains a list of all cases to be simulate.
To simulate them, run

>./run_simulations.sh

This bash script sets the system variable, which `run_simulations.py` does not do,
hence you should run the `.sh` rather than the `.py` file.

After this command, the output files and scripts will be in the directory `simulations`.

To run the regression tests, run

> ./install.sh
> export MODELICAPATH=/tmp/${USER}_obc_caseStudy_full_install/modelica-buildings
> ( cd SystemModel && ../bin/runUnitTests.py )

To post process the simulations, run

>./post_process.py

(This is not yet implemented.)

