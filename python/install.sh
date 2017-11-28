#!/bin/bash
# setup python things

set -o errexit
set -o nounset
set -o pipefail
. functions.sh

sudo apt-get -qq update
sudo apt-get -qq install python-dev python-pip python-setuptools \
                        python3-dev python3-pip python3-setuptools

# global modules
sudo -H pip install --quiet --upgrade pip virtualenv virtualenvwrapper
# user modules
pip3 install --quiet --upgrade --user thefuck

# make sure virtualenvwrapper location exists
mkdir -p "/home/${USER}/.virtualenvs"
