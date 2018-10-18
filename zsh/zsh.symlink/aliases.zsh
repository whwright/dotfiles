#!/usr/bin/env zsh
# aliases!

# external
source $(which virtualenvwrapper_lazy.sh)

# my aliases
alias grip="grep -i"
alias javarepl="java -jar /opt/javarepl.jar"
alias mylsblk="lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL"
# OSX compatible copy/paste
alias pbcopy="xclip -selection c"
alias pbpaste="xclip -selection clipboard -o"
alias psg="ps -ef | grep"
alias pyjson="python -m json.tool"
alias reload="source ~/.zshrc"
alias xo="xdg-open"
