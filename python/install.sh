#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
source lib.sh

# global modules
sudo -H pip install --quiet --upgrade pip virtualenv virtualenvwrapper

# make sure virtualenvwrapper location exists
mkdir -p "${HOME}/.virtualenvs"

# all submodules in python/ should be debinate projects and python3
info "Installing debinate packages..."
for module in $(git submodule--helper list | grep "python/" | awk '{print $4}'); do
    # module will look like "python/project-name"
    project_name=${module##python/}  # delete "python/" from the front of the string
    info "Installing ${project_name}"

    if ! [ -d "${module}/.debinate" ]; then
        echo "${module}" is not a debinate projects
        exit 1
    fi

    python_interpreter=python
    binary=null

    if [ -f ${module}/debinate.json ]; then
        new_python_interpreter=$(cat ${module}/debinate.json | jq '.python_interpreter' | remove-quotes)
        if [ "${new_python_interpreter}" != "null" ]; then
            python_interpreter=${new_python_interpreter}
        fi

        new_binary=$(cat ${module}/debinate.json | jq '.linked_binary' | remove-quotes)
        if [ "${new_binary}" != "null" ]; then
            binary=${new_binary}
        fi
    fi

    info "Building ${module} using ${python_interpreter} into binary ${binary}"
    pushd ${module} > /dev/null
    export DEBINATE_PYTHON=$(which ${python_interpreter})
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
            if [ "${binary}" != "null" ]; then
                sudo ln -svf /opt/${project_name}/.virtualenv/bin/${binary} /usr/local/bin/${binary}
            fi
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
