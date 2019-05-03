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
export NOTES=${HOME}/Dropbox/notes
if [ ! -d "${NOTES}" ]; then
    echo "WARNING: NOTES (${NOTES}) does not exist"
fi

########
# PATH #
########

if [ "$(uname -s)" = "Darwin" ]; then
    _safe_load_to_path "${HOME}/Library/Python/2.7/bin"
elif [ "$(uname -s)" = "Linux" ]; then
    _safe_load_to_path "${HOME}/.local/bin"
fi
