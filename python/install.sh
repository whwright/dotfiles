#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -x

if [[ "$(uname -s)" = "Linux" ]]; then
    echo "TODO: reasses Linux setup here"
    exit 1
    # sudo apt-get -qq update
    # sudo apt -qq install python-minimal python-pip python3-pip python3-dev python3-distutils python3-venv
fi

# this is currently tailored to the latest OSX, where we have sane defaults fo python3

# global packages
sudo -H python3 -m pip install --quiet --upgrade pip virtualenv

# user packages
python3 -m pip install --user pipx
python3 -m pip install --user virtualenvwrapper && \
    mkdir -p "${HOME}/.virtualenvs"

# pipx packages
pipx install zxcvbn-python
