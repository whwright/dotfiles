#!/bin/bash
# setup global python modules

. functions.sh

info "running python/install.sh"

MODULES=("thefuck")

for MODULE in $MODULES; do

    sudo -H pip install --upgrade "$MODULE"

    # TODO: revisit if we want to get rid of the password prompt
    #if ! pip freeze | grep $MODULE > /dev/null; then
    #    sudo -H pip install --upgrade $MODULE
    #fi

done

info "python modules installed"

