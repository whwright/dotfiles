#!/usr/bin/env zsh
# my config

# env variables
export EDITOR='vim'

# golang
if type go > /dev/null; then
    export GOPATH="${HOME}/Dev/go"
    PATH=${PATH}:${GOPATH}/bin
else
    echo "WARNING: go not installed"
fi

# aliases
eval "$(thefuck --alias)"
eval "$(hub alias -s)"

# aliases
alias grip="grep -i"
alias psg="ps -ef | grep"
alias pubip="curl http://canihazip.com/s/; echo ''"
alias cll="clear; ll"
alias javarepl="java -jar /opt/javarepl.jar"
alias reload="source ~/.zshrc"

# functions
function cdlast() {
    # cd into last item in current directory
    last=$(ls | tail -1)
    cd ${last}
}

function tmuxkillall() {
    # kill all tmux sessions except the current one
    curr=$(tmux display-message -p '#S')
    tmux kill-session -a -t ${curr}
}
