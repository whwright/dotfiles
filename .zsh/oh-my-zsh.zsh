#!/usr/bin/env zsh
# oh-my-zsh config

export ZSH=${HOME}/.oh-my-zsh
export ZSH_CUSTOM=${HOME}/.zsh/custom

#### theme config
# source gitprompt before theme
export ZSH_GIT_PROMPT_PYBIN=python3
[ -e "${HOME}/.zsh-git-prompt/zshrc.sh"   ] && source "${HOME}/.zsh-git-prompt/zshrc.sh"
ZSH_THEME="bira-clone"

#### config
zstyle ':omz:lib:theme-and-appearance' gnu-ls yes

source ${ZSH}/oh-my-zsh.sh

unset LESS  # removes default `-R` option
