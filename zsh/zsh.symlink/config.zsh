#!/usr/bin/env zsh

# path
function _safe_load_to_path() {
    local args=()
    local load_first=false

    while [[ $# -gt 0 ]]; do
        key=${1}
        case ${key} in
            --load-first)
                load_first=true
                ;;
            *)
                args+="${key}"
                ;;
        esac
        shift
    done

    local new_path_item=${args[1]}
    if [ -d ${new_path_item} ]; then
        if [ ${load_first} = true ]; then
            export PATH=${new_path_item}:${PATH}
        else
            export PATH=${PATH}:${new_path_item}
        fi
    fi
}
_safe_load_to_path "${HOME}/.blscripts"
_safe_load_to_path "${HOME}/.whwscripts"

# env variables
export EDITOR='vim'

# golang
if type go > /dev/null; then
    export GOPATH="${HOME}/Dev/go"
    PATH=${PATH}:${GOPATH}/bin
else
    echo "WARNING: go not installed"
fi

# nvm
# export NVM_DIR="/home/whw/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# Hacky nvm default. https://github.com/creationix/nvm/issues/860
_safe_load_to_path --load-first "${HOME}/.nvm/versions/node/v4.4.4/bin"
# _safe_load_to_path --load-first "${HOME}/.nvm/versions/node/v6.5.0/bin"
# _safe_load_to_path --load-first "${HOME}/.nvm/versions/node/v0.12.9/bin"

# aliases
eval "$(thefuck --alias)"

# my aliases
alias grip="grep -i"
alias psg="ps -ef | grep"
alias pubip="curl http://canihazip.com/s/; echo ''"
alias cll="clear; ll"
alias javarepl="java -jar /opt/javarepl.jar"
alias reload="source ~/.zshrc"
alias pyjson="python -m json.tool"

# functions
function cdlast() {
    # cd into last item in current directory
    last=$(ls -d */ | tail -1)
    cd ${last}
}

function tmux_killall() {
    # kill all tmux sessions except the current one
    curr_session=$(tmux display-message -p '#S')
    tmux kill-session -a -t ${curr_session}
}
alias tka="tmux_killall"

function tmux_killssh() {
    # kill all ssh sessions
    # assumes sessions are named "ssh [thing] [port]"
    IFS=$'\n' ssh_sessions=($(tmux ls -F "#{session_name}" | grep "^ssh [a-zA-Z\-]\{1,\} [0-9]\{4,\}"))
    for session in "${ssh_sessions[@]}"; do
        tmux kill-session -t "${session}"
    done
}
alias tks="tmux_killssh"

function git_checker() {
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

function reset_virtualenv() {
    local venv
    if [ $# -gt 0 ]; then
        venv="/home/whw/.virtualenvs/${1}"
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
        python_interp=$(which python3)
    else
        echo "ERROR: invalid python version? ${python_version}"
        return 1
    fi

    rmvirtualenv ${venv_name}
    mkvirtualenv ${venv_name} --python ${python_interp}
}