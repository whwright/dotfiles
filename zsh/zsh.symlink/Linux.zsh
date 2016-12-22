#!/usr/bin/env zsh
# Linux config

export PATH=${PATH}:~/.local/bin

# keybind for KP_ENTER (https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=685511)
if (( ${+terminfo[kent]} )); then
    kent="${terminfo[kent]}"
else
    kent=$(TERM=xterm echoti kent 2>/dev/null)
    # If there is nothing in `$kent' yet, use "ESC O M", which is
    # what xterm and urxvt use.
    [[ -z "$kent" ]] && kent=$'\eOM'
fi
bindkey "$kent" accept-line
unset kent

bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

# eval $(dircolors ${HOME}/.dircolors/256dark)

alias mylsblk="lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL"
# OSX compatible copy/paste
alias pbcopy="xclip -selection c"
alias pbpaste="xclip -selection clipboard -o"
alias lock="gnome-screensaver-command --lock"
