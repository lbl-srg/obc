#!/bin/bash
set -e
TMP=/tmp/$USER/obc_caseStudy_full_install
TMP_MBL=/tmp/${USER}_obc_caseStudy_full_install/modelica-buidings
TMP_BUP=/tmp/${USER}_obc_caseStudy_full_install/BuildingsPy

get_repo(){
    TMPDIR=$1
    REPO=$2
    HASH=$3
    if [ -d $TMPDIR ]; then
        cd $TMPDIR
        if [ -n "$(git status --porcelain)" ]; then
            # Local changes exist
            echo `pwd`
            echo "Error, aborting due to local changes in $TMPDIR"
            exit 1
        fi;
    else
      # Directory does not exist
      git clone $REPO $TMPDIR
    fi;
    cd $TMPDIR
    # Switch to specific commit (head of master as of Aug. 23, 2021)
    git checkout $HASH
    echo "Cloned repository into `pwd`"
}

get_repo $TMP_MBL https://github.com/lbl-srg/modelica-buildings.git 2452b93d01835350c4030d5f799bab9456836ecc
get_repo $TMP_BUP https://github.com/lbl-srg/BuildingsPy.git 459e042f4257f5552ddbb08aa4b5a2e234ba9956

echo "Don't forget to set export MODELICAPATH=$TMP_MBL"
echo "Don't forget to set export PYTHONPATH=$TMP_BUP:$PYTHONPATH"
