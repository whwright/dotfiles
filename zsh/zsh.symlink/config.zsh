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
alias tls="tmux ls"

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

tmux_killssh() {
    # kill all ssh sessions
    # assumes sessions are named "ssh [thing] [port]"
    IFS=$'\n' ssh_sessions=($(tmux ls -F "#{session_name}" | grep "^ssh [a-zA-Z\-]\{1,\} [0-9]\{4,\}"))
    for session in "${ssh_sessions[@]}"; do
        tmux kill-session -t "${session}"
    done
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
