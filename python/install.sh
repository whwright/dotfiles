#!/bin/bash
# setup global python modules

. functions.sh

MODULES=("virtualenv" "virtualfish" "thefuck")

for MODULE in "${MODULES[@]}"; do

    sudo -H pip install --upgrade "$MODULE"

    if [ $? -ne 0 ]; then
        fail "error occurred while installed $MODULE"
    fi

    # TODO: revisit if we want to get rid of the password prompt
    #if ! pip freeze | grep $MODULE > /dev/null; then
    #    sudo -H pip install --upgrade $MODULE
    #fi

done

if [ ${UNAME} == "Linux" ]; then
    mkdir -p "/home/${USER}/.virtualenvs"
else
    mkdir -p "/Users/${USER}/.virtualenvs"
fi
