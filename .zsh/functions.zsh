#!/usr/bin/env zsh

function __display_cnotif_darwin() {
    local return_value="${1}"
    local end_time="${2}"
    local last_cmd="${3}"

    local title
    if [[ ${return_value} == 0 ]]; then
        title="SUCCESS: ${end_time}"
    else
        title="FAILED: ${end_time}"
    fi
    local text="↪ ${last_cmd} \n RV: ${return_value}"

    osascript -e "display notification \"${text}\" with title \"${title}\""
}

function __display_cnotif_linux() {
    local return_value="${1}"
    local end_time="${2}"
    local last_cmd="${3}"

    return 1
}

# Show a system notification after a command is completed.
# Usage: ${some command} ; cnotif
function cnotif() {
    local return_value=$?                  # get return value of the last command
    local end_time=$(date)                 # get time of completion
    local last_cmd=${history[${HISTCMD}]}  # get current command
    last_cmd=${last_cmd%[;&|]*}            # remove "; alert" from it

    if [[ ${return_value} -eq 0 ]]; then
        title="Command complete"
    else
        title="Command failed"
    fi

    message="${end_time} ${last_cmd}"

    terminal-notifier -title "${title}" -message "${message}" -sound default

    # local func
    # if [[ "$(uname -s)" == "Darwin" ]]; then
    #     func=__display_cnotif_darwin
    # # TODO: enable when aalert -> cnotif
    # # elif [[ "$(uname -s)" == "Linux" ]]; then
    # #     func=__display_cnotif_linux
    # else
    #     echo "Unsupported OS: $(uname -s)"
    #     return 1
    # fi

    # "${func}" "${return_value}" "${end_time}" "${last_cmd}"
}

# cd into last directory in cwd
function cdlast() {
    local last=$(ls -d */ | tail -1)
    cd ${last}
}

# mkdir and cd into it
function mkcd() {
    if [ $# -ne 1 ]; then
        echo "usage: mkcd <DIRECTORY>"
        return 1
    fi

    mkdir -p "${1}"
    cd "${1}"
}

function reload() {
    if [[ ! -z "${VIRTUAL_ENV}" ]] && type deactivate > /dev/null ; then
        deactivate
    fi
    exec "${SHELL}"
}

# resets a virtualenv
# accepts a virtualenv as a parameter or uses the currently active virtualenv
function reset_virtualenv() {
    local venv
    if [ $# -gt 0 ]; then
        venv="${HOME}/.virtualenvs/${1}"
    else
        if [ -z "${VIRTUAL_ENV}" ]; then
            echo "ERROR: needs active virtualenv, or one passed as a parameter"
            return 1
        fi
        venv="${VIRTUAL_ENV}"
    fi
    local venv_name=$(basename ${venv})

    if [ ! -d "${venv}" ]; then
        echo "ERROR: could not find ${venv}"
        return 1
    fi

    # deactivate if virtualenv is active
    if [ ! -z "${VIRTUAL_ENV}" ]; then
        deactivate
    fi

    # python2 prints version to stderr but python3 uses stdout
    python_version=$(${venv}/bin/python --version 2>&1 | sed 's/Python //')

    local python_interp
    # right now only supporting python 2 vs 3
    if [ "${python_version:0:1}" = "2" ]; then
        python_interp=$(which python2)
    elif [ "${python_version:0:1}" = "3" ]; then
        minor="${python_version:1:2}"
        which "python3${minor}" > /dev/null
        if [ $? -eq 0 ]; then
            python_interp=$(which "python3${minor}")
        else
            python_interp=$(which python3)
        fi
    else
        echo "ERROR: invalid python version? ${python_version}"
        return 1
    fi

    rmvirtualenv ${venv_name}
    mkvirtualenv ${venv_name} --python ${python_interp}
}

function tarball() {
    if [ $# -ne 1 ] || [ ! -d ${1} ]; then
        echo "usage: tarball [DIRECTORY]"
        return 1
    fi

    local target="${1}"
    echo "creating tarball from ${target}"
    # replace spaces in dest
    tar -czvf "${target// /_}.tar.gz" "${target}"
}

# kill all tmux sessions except the current one
function tmux_killall() {
    curr_session=$(tmux display-message -p '#S')
    tmux kill-session -a -t ${curr_session}
}
alias tkall="tmux_killall"

# kill all ssh sessions
# assumes sessions are named "ssh [thing] [port]"
function tmux_killssh() {
    IFS=$'\n' ssh_sessions=($(tmux ls -F "#{session_name}" | grep "^ssh [a-zA-Z\-]\{1,\} [0-9]\{4,\}"))
    for session in "${ssh_sessions[@]}"; do
        tmux kill-session -t "${session}"
    done
}
alias tkssh="tmux_killssh"

function fetchpr() {
    local branch="${1}"
    git fetch && git checkout "${branch}" && git pull
}

