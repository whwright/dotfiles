#!/bin/bash
# setup python things

set -o errexit
set -o nounset
set -o pipefail
source functions.sh

# global modules
sudo -H pip install --quiet --upgrade pip virtualenv virtualenvwrapper

# make sure virtualenvwrapper location exists
mkdir -p "${HOME}/.virtualenvs"

# all submodules in python/ should be debinate projects and python3
info "Installing debinate packages..."
for module in $(git submodule--helper list | grep "python/" | awk '{print $4}'); do
    projet_name=${module##*/}
    if ! [ -d "${module}/.debinate" ]; then
        echo "${module}" is not a debinate projects
        exit 1
    fi

    info "Building ${module}"
    pushd ${module} > /dev/null
    if ! [ -f .python-version ]; then
        echo ".python-verison file not found in ${module}"
        exit 1
    fi
    python_version=$(cat .python-version)
    export DEBINATE_PYTHON=$(which ${python_version})
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
