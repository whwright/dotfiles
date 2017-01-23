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

# aliases
alias grip="grep -i"
alias psg="ps -ef | grep"
alias pubip="curl http://canihazip.com/s/; echo ''"
alias cll="clear; ll"
alias javarepl="java -jar /opt/javarepl.jar"
alias reload="source ~/.zshrc"
alias pyjson="python -m json.tool"

# functions
cdlast() {
    # cd into last item in current directory
    last=$(ls | tail -1)
    cd ${last}
}

tmux_killall() {
    # kill all tmux sessions except the current one
    curr_session=$(tmux display-message -p '#S')
    tmux kill-session -a -t ${curr_session}
}

git_checker() {
    local dir_read_in="${1:-${PWD}}"

    for git_dir in $(find ${dir_read_in} -type d -name "*.git"); do
        local repo_dir=$(dirname ${git_dir})
        cd ${repo_dir}
        if [[ $(git status --porcelain) ]]; then
             echo "${repo_dir} is dirty"
        fi
        cd - > /dev/null
    done
}
