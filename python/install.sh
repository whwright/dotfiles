#!/bin/bash
# setup global python module

. functions.sh

if [ $(uname -s) == "Linux" ]; then
    APT_DEPENDS=("python-dev" "python-pip" "python-setuptools")
    APT_DEPENDS+=("python3-dev" "python3-setuptools")
    sudo apt-get update
    for ITEM in "${APT_DEPENDS[@]}"; do
        echo "Installing ${ITEM}"
        sudo apt-get install -y "${ITEM}"
    done
fi

# check if pip is latest version
LATEST_PIP=$(pip search pip | grep "^pip ([0-9\.]\{1,\})" | cut -d "(" -f2 | cut -d ")" -f1)
CURRENT_PIP=$(pip --version | awk '{print $2}')
if [ "${LATEST_PIP}" != "${CURRENT_PIP}" ]; then
    sudo -H pip install --upgrade pip
else
    info "pip is latest verion ${LATEST_PIP}"
fi

GLOBAL_MODULES=("virtualenv" "virtualenvwrapper")
for MODULE in "${GLOBAL_MODULES[@]}"; do
    pip freeze | grep "${MODULE}" > /dev/null
    if [ $? -ne 0 ]; then
        info "installing global module ${MODULE}"
        sudo -H pip install --upgrade "${MODULE}"
        if [ $? -ne 0 ]; then
            fail "error occurred while installed $MODULE"
        fi
    else
        info "global module ${MODULE} already installed"
    fi
done

USER_MODULES=("virtualfish" "thefuck")
for MODULE in "${USER_MODULES[@]}"; do
    pip freeze | grep "${MODULE}" > /dev/null
    if [ $? -ne 0 ]; then
        info "installing user module ${MODULE}"
        pip install --upgrade --user "${MODULE}"
        if [ $? -ne 0 ]; then
            fail "error occurred while installed $MODULE"
        fi
    else
        info "user module ${MODULE} already installed"
    fi
done

if [ $(uname -s) == "Linux" ]; then
    mkdir -p "/home/${USER}/.virtualenvs"
else
    mkdir -p "/Users/${USER}/.virtualenvs"
fi
