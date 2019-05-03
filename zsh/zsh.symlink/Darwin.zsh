#!/usr/bin/env zsh

############
# KEYBINDS #
############

# needs these to go left/right words in iTerm
bindkey "[D" backward-word
bindkey "[C" forward-word
# same thing as above but in tmux
bindkey "OD" backward-word
bindkey "OC" forward-word
