#!/bin/bash
# setup python things

set -o errexit
set -o nounset
set -o pipefail
source functions.sh

# TODO: revisit this (https://github.com/whwright/dotfiles/issues/28)
# sudo apt-get -qq update
# sudo apt-get -qq install python-dev python-pip python-setuptools \
#                         python3-dev python3-pip python3-setuptools
#
# global modules
# sudo -H pip install --quiet --upgrade pip virtualenv virtualenvwrapper
#
# make sure virtualenvwrapper location exists
# mkdir -p "/home/${USER}/.virtualenvs"

# all submodules in python/ should be debinate projects
# and python3
info "Installing debinate packages..."
export DEBINATE_PYTHON=$(which python3)
for module in $(git submodule--helper list | grep "python/" | awk '{print $4}'); do
    projet_name=${module##*/}
    if ! [ -d "${module}/.debinate" ]; then
        echo "${module}" is not a debinate projects
        exit 1
    fi

    info "Building ${module}"
    pushd ${module} > /dev/null
    debinate clean > /dev/null
    debinate package > /dev/null
    popd > /dev/null

    debs=($(find ${module} -name *.deb))

    user "Are you sure you want to install ${debs[0]}?"
    read -p "" action
    case "${action}" in
        y)
            info "Installing ${debs[0]}"
            sudo dpkg -i ${debs[0]}
            sudo ln -svf /opt/${projet_name}/.virtualenv/bin/${projet_name} /usr/local/bin/${projet_name}
            sudo chown ${USER}:${USER} -R /opt/${projet_name}
            ;;
        n)
            echo "Not installing"
            ;;
        *)
            echo "Unknown choice"
            ;;
    esac
done

# things I know that need to be done after sub modules above

# keep
mkdir -p /home/${USER}/.keep
ln -s ~/Dropbox/Apps/keep/commands.json /home/${USER}/.keep/commands.json
