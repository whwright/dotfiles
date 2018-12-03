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
    project_name=${module##*/}
    if ! [ -d "${module}/.debinate" ]; then
        echo "${module}" is not a debinate projects
        exit 1
    fi

    python_version=python
    binary=${project_name}

    # TODO: this logic is deprecate, replace with debinate.json
    if [ -f ${module}/.python-version ]; then
        python_version=$(cat ${module}/.python-version)
    fi

    if [ -f ${module}/debinate.json ]; then
        new_python_version=$(cat ${module}/debinate.json | jq '.python' | remove-quotes)
        if [ "${new_python_version}" != "null" ]; then
            python_version=${new_python_version}
        fi

        new_binary=$(cat ${module}/debinate.json | jq '.binary' | remove-quotes)
        if [ "${new_python_version}" != "null" ]; then
            binary=${new_binary}
        fi
    fi

    info "Building ${module} using ${python_version} into binary ${binary}"
    pushd ${module} > /dev/null
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
            # TODO: this assumes there will be a binary like this
            sudo ln -svf /opt/${project_name}/.virtualenv/bin/${binary} /usr/local/bin/${binary}
            sudo chown ${USER}:${USER} -R /opt/${project_name}
            ;;
        n)
            echo "Not installing"
            ;;
        *)
            echo "Unknown choice"
            ;;
    esac
done
