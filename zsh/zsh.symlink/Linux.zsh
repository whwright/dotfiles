#!/usr/bin/env zsh
# Linux config

PATH=${PATH}:~/.local/bin

# keybind for KP_ENTER (https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=685511)
bindkey "${terminfo[kent]}" accept-line

# eval $(dircolors ${HOME}/.dircolors/256dark)

alias mylsblk="lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL"
# OSX compatible copy/paste
alias pbcopy="xclip -selection c"
alias pbpaste="xclip -selection clipboard -o"
