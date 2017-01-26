#!/usr/bin/env zsh
# oh-my-zsh config

export ZSH=${HOME}/.oh-my-zsh
ZSH_CUSTOM=${HOME}/.zsh/custom

#### theme config
# source gitprompt before theme
[ -e "${HOME}/.zsh-git-prompt/zshrc.sh"   ] && source "${HOME}/.zsh-git-prompt/zshrc.sh"
ZSH_THEME="bira-clone"

#### plugin config
# tmux config
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOCONNECT=true
# virtualenvwrapperconfig
DISABLE_VENV_CD=1
plugins=(gitfast virtualenvwrapper tmux)

source ${ZSH}/oh-my-zsh.sh
