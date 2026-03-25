#!/usr/bin/env zsh
# oh-my-zsh config
# NOTE: After implementing starship and removing / porting plugins into zsh config
# I am only using oh-my-zsh for the fancy tab complete in the shell. If that could be
# replaced I don't need omz.

export ZSH=${HOME}/.oh-my-zsh

# LEGACY THEME CONFIG
# I used this theme and the zsh-git-prompt before starship
# this can probably just be removed
# export ZSH_CUSTOM=${HOME}/.zsh/custom
# must source gitprompt before theme
# export ZSH_GIT_PROMPT_PYBIN=python3
# [ -e "${HOME}/.zsh-git-prompt/zshrc.sh"   ] && source "${HOME}/.zsh-git-prompt/zshrc.sh"
# ZSH_THEME="bira-clone"

# TODO: I don't remember why I had this; make sure ls on linux is okay
# zstyle ':omz:lib:theme-and-appearance' gnu-ls yes

source ${ZSH}/oh-my-zsh.sh

# omz sets the -R flag by default; this removes it
# The -R flag makes less pass through raw ANSI escape codes (colors)
unset LESS  # removes default `-R` option
