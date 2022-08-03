#!/usr/bin/env zsh

activate_venv() {
    venv_name="${1}"

    if [ ! -z "${VIRTUAL_ENV}" ]; then
        if [ "${VIRTUAL_ENV}" = "${HOME}/.virtualenvs/${venv_name}" ]; then
            return 0
        else
            deactivate
        fi
    fi
    workon ${venv_name}
}

op() {
    activate_venv "opcity"
    cd ~/code/opcity
}

rapi() {
    activate_venv "referral-api"
    cd ~/code/referral-api
}

whodis() {
    activate_venv "whodis"
    cd ~/code/whodis
}