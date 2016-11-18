#!/bin/bash
# setup global python module

. functions.sh

APT_DEPENDS=("python-dev" "python-pip" "python-setuptools")
APT_DEPENDS+=("python3-dev" "python3-setuptools")
sudo apt-get update
for ITEM in "${APT_DEPENDS[@]}"; do
    echo "Installing ${ITEM}"
    sudo apt-get install -y "${ITEM}"
done

sudo pip install --upgrade pip

GLOBAL_MODULES=("virtualenv" "virtualenvwrapper")
for MODULE in "${GLOBAL_MODULES[@]}"; do
    info "installing global module ${MODULE}"
    sudo pip install --upgrade "${MODULE}"
    if [ $? -ne 0 ]; then
        fail "error occurred while installed $MODULE"
    fi
done

USER_MODULES=("virtualfish" "thefuck")
for MODULE in "${USER_MODULES[@]}"; do
    info "installing user module ${MODULE}"
    pip install --upgrade --user "${MODULE}"
    if [ $? -ne 0 ]; then
        fail "error occurred while installed $MODULE"
    fi
done

if [ $(uname -s) == "Linux" ]; then
    mkdir -p "/home/${USER}/.virtualenvs"
else
    mkdir -p "/Users/${USER}/.virtualenvs"
fi
