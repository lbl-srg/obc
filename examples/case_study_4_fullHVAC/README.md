This directory contains the files for the case study
that has a primary and secondary HVAC system.

To check out the library files, run

>./install.sh

This will install the Buildings Library and BuildingsPy into the `tmp` directory
which is not under version control.

The models used for the case study are in `SystemModel`.

The file `cases.py` contains a list of all cases to be simulate.
To simulate them, run

>./run_simulations.py

To post process the simulations, run

>./post_process.py

