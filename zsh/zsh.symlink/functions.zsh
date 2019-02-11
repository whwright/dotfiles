#!/usr/bin/env zsh
# my zsh functions
# keep these alphabetized

# awesome notification
# https://www.reddit.com/r/awesomewm/comments/1gyt8x/notifications_for_completed_commands/
function aalert {
    local return_value=$?                  # get return value of the last command
    local end_time=$(date)                 # get time of completion
    local last_cmd=${history[${HISTCMD}]}  # get current command
    last_cmd=${last_cmd%[;&|]*}            # remove "; alert" from it

    # set window title so we can get back to it
    echo -ne "\e]2;$last_cmd\a"

    last_cmd=${last_cmd//\"/'\"'}        # replace " for \" to not break lua format

    # check if the command was successful
    local bg_color
    local fg_color
    if [[ ${return_value} == 0 ]]; then
        return_value="SUCCESS"
        bg_color="beautiful.bg_normal"
        fg_color="beautiful.fg_normal"
    else
        return_value="FAILURE"
        bg_color="beautiful.bg_urgent"
        fg_color="beautiful.fg_urgent"
    fi

    # compose the notification
    local message="naughty.notify({ \
                title   = \"Command completed on: \t\t${end_time}\", \
                text    = \"↪ ${last_cmd}\" .. newline .. \"${return_value}\", \
                timeout = 0, \
                bg      = ${bg_color},
                fg      = ${fg_color},
            })"
    # send it to awesome
    echo ${message} | awesome-client
}

# cd into last directory in cwd
function cdlast() {
    local last=$(ls -d */ | tail -1)
    cd ${last}
}

# finds dirty git repos
# uses $PWD or the 1st argument given as the root to look through
# TODO: I think there's a better way to write a git script
function git_dirty() {
    local dir_read_in="${1:-${PWD}}"

    for git_dir in $(find ${dir_read_in} -type d -name "*.git"); do
        local repo_dir=$(dirname ${git_dir})
        cd ${repo_dir}
        if [[ $(git status --porcelain) ]]; then
             echo "${repo_dir} is dirty"
        fi
        cd - > /dev/null
    done
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

# open notes
function notes() {
    terminal_velocity "${NOTES}"
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
    echo ${python_version}

    local python_interp
    # right now only supporting python 2 vs 3
    if [ "${python_version:0:1}" = "2" ]; then
        python_interp=$(which python2)
    elif [ "${python_version:0:1}" = "3" ]; then
        python_interp=$(which python3)
    else
        echo "ERROR: invalid python version? ${python_version}"
        return 1
    fi

    rmvirtualenv ${venv_name}
    mkvirtualenv ${venv_name} --python ${python_interp}
}

# use ripgrep on notes directory
function rgnotes() {
    rg "$@" ${NOTES}
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
