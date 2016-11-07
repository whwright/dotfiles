#!/bin/bash
# setup global python module

. functions.sh

MODULES=("virtualenv" "virtualfish" "thefuck")

for MODULE in "${MODULES[@]}"; do
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

