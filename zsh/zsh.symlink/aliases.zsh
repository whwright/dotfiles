#!/usr/bin/env zsh
# aliases!

# external
source $(which virtualenvwrapper_lazy.sh)

# my aliases
alias grip="grep -i"
alias ll="ls -lhN"
alias la="ls -lAhN"
alias psg="ps -ef | grep"
alias pyjson="python -m json.tool"
alias reload="source ~/.zshrc"

if [ "$(uname -s)" = "Darwin" ]; then
    alias xo="open"  # I'm too used to my own `xo`
elif [ "$(uname -s)" = "Linux" ]; then
    alias mylsblk="lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL"
    # OSX compatible copy/paste
    alias pbcopy="xclip -selection c"
    alias pbpaste="xclip -selection clipboard -o"
    alias xo="xdg-open"
fi
