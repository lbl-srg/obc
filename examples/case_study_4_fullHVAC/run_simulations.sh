#!/bin/bash
set -e
export PYTHONPATH=/tmp/${USER}_obc_caseStudy_full_install/BuildingsPy
export MODELICAPATH=/tmp/${USER}_obc_caseStudy_full_install/modelica-buildings
python3 ./run_simulations.py
exit $?
