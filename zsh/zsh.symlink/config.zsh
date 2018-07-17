#!/usr/bin/env zsh

#######################
# ENVIRONMENT VARIABLES
#######################

# zsh history
HISTSIZE=100000
SAVEHIST=100000
HIST_IGNORE_SPACE=true
HIST_NO_STORE=true
HIST_NO_FUNCTIONS=true

export EDITOR='vim'
export NOTES=/home/${USER}/Dropbox/Documents/Notes
if [ ! -d "${NOTES}" ]; then
    echo "WARNING: NOTES (${NOTES}) does not exist"
fi

# TODO:
# reminants of trying to make alt-c include hidden directories
# export FZF_ALT_C_COMMAND="command find -L . -mindepth 1 \\( -path '*/\\.*' \
#                                                             -o -fstype 'sysfs' \
#                                                             -o -fstype 'devfs' \
#                                                             -o -fstype 'devtmpfs' \
#                                                             -o -fstype 'proc' \\) -prune -o -type d -print 2> /dev/null | cut -b3-"
# export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

######
# PATH
######

# function that only loads to path if the directory exists
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

# my private scripts
_safe_load_to_path "${HOME}/.whwscripts"
_safe_load_to_path "${HOME}/.blscripts"
# programing language binary paths
_safe_load_to_path "/usr/local/go/bin"   # go
_safe_load_to_path "${HOME}/.local/bin"  # python
_safe_load_to_path "${HOME}/.cargo/bin"  # rust

# golang
if type go > /dev/null; then
    export GOPATH="${HOME}/Dev/go"
    PATH=${PATH}:${GOPATH}/bin
else
    echo "WARNING: go not installed"
fi

# nvm
# Hacky nvm default. https://github.com/creationix/nvm/issues/860
# _safe_load_to_path --load-first "${HOME}/.nvm/versions/node/v0.12.9/bin"
# _safe_load_to_path --load-first "${HOME}/.nvm/versions/node/v4.4.4/bin"
_safe_load_to_path --load-first "${HOME}/.nvm/versions/node/v6.5.0/bin"
