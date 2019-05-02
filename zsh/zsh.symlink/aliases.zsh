#!/usr/bin/env zsh
# aliases!

# external
source $(which virtualenvwrapper_lazy.sh)

# my aliases
alias ll="ls -lhN"
alias la="ls -lAhN"
alias psg="ps -ef | grep"
alias pyjson="python -m json.tool"
alias reload="source ~/.zshrc"
# added by rdooley
alias pycclean="find . -name '*.pyc' -exec rm -rf {} \;"
alias lh="ls -lh"
alias batterquery="upower -i /org/freedesktop/UPower/devices/battery_BAT0 | ack-grep percentage | cut -f2"
