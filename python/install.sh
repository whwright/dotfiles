#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
source lib.sh

# we need pip first
if ! type pip > /dev/null 2>&1; then
    curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
    sudo python3 /tmp/get-pip.py
fi

if [[ "$(uname -s)" = "Linux" ]]; then
    sudo apt-get update
    sudo apt install python3-venv
fi

# global packages
sudo -H pip install --quiet --upgrade pip virtualenv
sudo python3 -m pip install --user pipx

# non-global packages
pipx install virtualenvwrapper
mkdir -p "${HOME}/.virtualenvs"

pipx install zxcvbn-python
pip install --user terminal_velocity  # needs a python2 venv :(
