#!/usr/bin/env zsh

#########################
# ENVIRONMENT VARIABLES #
#########################

# zsh history
HISTSIZE=100000
SAVEHIST=100000
HIST_IGNORE_SPACE=true
HIST_NO_STORE=true
HIST_NO_FUNCTIONS=true

export EDITOR='vim'
export NOTES=${HOME}/Dropbox/Notes
if [ ! -d "${NOTES}" ]; then
    echo "WARNING: NOTES (${NOTES}) does not exist"
fi

########
# PATH #
########

# golang
# TODO: redo this crap
if type go > /dev/null; then
    export GOPATH="${HOME}/Dev/go"
    _safe_load_to_path "${GOPATH}/bin"
else
    echo "WARNING: go not installed"
fi

# nvm
# TODO: redo this crap
export NVM_DIR="${HOME}/.nvm"
[ -s "${NVM_DIR}/nvm.sh" ] && source "${NVM_DIR}/nvm.sh" --no-use
# Hacky nvm default. https://github.com/creationix/nvm/issues/860
# _safe_load_to_path --load-first "${HOME}/.nvm/versions/node/v0.12.9/bin"
# _safe_load_to_path --load-first "${HOME}/.nvm/versions/node/v4.4.4/bin"
# _safe_load_to_path --load-first "${HOME}/.nvm/versions/node/v6.5.0/bin"
_safe_load_to_path --load-first "${HOME}/.nvm/versions/node/v8.11.4/bin"
