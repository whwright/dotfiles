#!/bin/bash
# setup python things

set -o errexit
set -o nounset
set -o pipefail
. functions.sh

if [ $(uname -s) == "Linux" ]; then
    sudo apt-get update
    sudo apt-get install python-dev python-pip python-setuptools \
                         python3-dev python3-setuptools
fi

# global modules
sudo -H pip install --upgrade pip virtualenv virtualenvwrapper
# user modules
pip install --upgrade --user thefuck

# make sure virtualenvwrapper location exists
if [ $(uname -s) == "Linux" ]; then
    mkdir -p "/home/${USER}/.virtualenvs"
elif [ $(uname -s) == "Darwin" ]; then
    mkdir -p "/Users/${USER}/.virtualenvs"
fi
