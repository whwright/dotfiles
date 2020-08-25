#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [[ "$(uname -s)" = "Linux" ]]; then
    sudo apt-get -qq update
    sudo apt -qq install python-minimal python3-dev python3-distutils python3-venv
fi

if ! type pip > /dev/null 2>&1; then
    curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
    sudo python3 /tmp/get-pip.py
fi

# global packages
sudo -H pip install --quiet --upgrade pip virtualenv
# pipx
python3 -m pip install --user pipx

# user/pipx packages
pip install --user virtualenvwrapper
mkdir -p "${HOME}/.virtualenvs"

pipx install zxcvbn-python
pip install --user terminal_velocity  # needs a python2 venv :(

