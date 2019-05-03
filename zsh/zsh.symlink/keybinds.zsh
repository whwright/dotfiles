#!/usr/bin/env zsh

if [ "$(uname -s)" = "Darwin" ]; then
    # needs these to go left/right words in iTerm
    bindkey "[D" backward-word
    bindkey "[C" forward-word
    # same thing as above but in tmux
    bindkey "OD" backward-word
    bindkey "OC" forward-word
elif [ "$(uname -s)" = "Linux" ]; then
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
fi
