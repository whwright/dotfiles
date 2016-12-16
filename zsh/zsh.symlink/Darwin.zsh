PATH=${PATH}:~/Library/Python/2.7/bin
PATH=${PATH}:~/.blscripts
# Hacky nvm default. https://github.com/creationix/nvm/issues/860
export PATH=${HOME}/.nvm/versions/node/v0.12.9/bin/:${PATH}

# needs these to go left/right words in iTerm
bindkey "[D" backward-word
bindkey "[C" forward-word
# same thing as above but in tmux
bindkey "OD" backward-word
bindkey "OC" forward-word
