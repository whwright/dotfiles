#!/usr/bin/env zsh
# oh-my-zsh config

export ZSH=${HOME}/.oh-my-zsh
export ZSH_CUSTOM=${HOME}/.zsh/custom

#### theme config
ZSH_THEME="sorin"

#### plugins
# gitfast - zsh completion wrapper for git
# tmux
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOCONNECT=false
plugins=(gitfast tmux git cabal pip python virtualenvwrapper)

source ${ZSH}/oh-my-zsh.sh
