#!/bin/bash
# setup global python module

. functions.sh

if [ $(uname -s) == "Linux" ]; then
    sudo apt-get update
    sudo apt-get install python-dev python-pip python-setuptools \
                         python3-dev python3-setuptools
fi

sudo -H pip install --upgrade pip virtualenv virtualenvwrapper
pip install --upgrade --user thefuck

if [ $(uname -s) == "Linux" ]; then
    mkdir -p "/home/${USER}/.virtualenvs"
elif [ $(uname -s) == "Darwin" ]; then
    mkdir -p "/Users/${USER}/.virtualenvs"
fi
