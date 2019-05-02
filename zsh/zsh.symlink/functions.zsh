#!/usr/bin/env zsh
# my zsh functions
# keep these alphabetized

# cd into last directory in cwd
function cdlast() {
    local last=$(ls -d */ | tail -1)
    cd ${last}
}

# finds dirty git repos
# uses $PWD or the 1st argument given as the root to look through
# TODO: I think there's a better way to write a git script
function git_dirty() {
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

# mkdir and cd into it
function mkcd() {
    if [ $# -ne 1 ]; then
        echo "usage: mkcd <DIRECTORY>"
        return 1
    fi

    mkdir -p "${1}"
    cd "${1}"
}

function tarball() {
    if [ $# -ne 1 ] || [ ! -d ${1} ]; then
        echo "usage: tarball [DIRECTORY]"
        return 1
    fi

    local target="${1}"
    echo "creating tarball from ${target}"
    # replace spaces in dest
    tar -czvf "${target// /_}.tar.gz" "${target}"
}

# kill all tmux sessions except the current one
function tmux_killall() {
    curr_session=$(tmux display-message -p '#S')
    tmux kill-session -a -t ${curr_session}
}
alias tkall="tmux_killall"

# kill all ssh sessions
# assumes sessions are named "ssh [thing] [port]"
function tmux_killssh() {
    IFS=$'\n' ssh_sessions=($(tmux ls -F "#{session_name}" | grep "^ssh [a-zA-Z\-]\{1,\} [0-9]\{4,\}"))
    for session in "${ssh_sessions[@]}"; do
        tmux kill-session -t "${session}"
    done
}
alias tkssh="tmux_killssh"

# some utility functions
function countdown(){
   date1=$((`date +%s` + $1));
   while [ "$date1" -ge `date +%s` ]; do
     echo -ne "$(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
     sleep 0.1
   done
}
function stopwatch(){
  date1=`date +%s`;
   while true; do
    echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r";
    sleep 0.1
   done
}
aws-sns-list-subscriptions ()
{
    aws sns list-subscriptions | jq '.Subscriptions[]|{Protocol,Endpoint,TopicArn}'
}

function aalert {
    RVAL=$?                         # get return value of the last command
    DATE=$(date)                    # get time of completion
    LAST=${history[${HISTCMD}]}     # get current command
    LAST=${LAST%[;&|]*}             # remove "; alert" from it

    # set window title so we can get back to it
    echo -ne "\e]2;$LAST\a"

    LAST=${LAST//\"/'\"'}        # replace " for \" to not break lua format

    # check if the command was successful
    if [[ ${RVAL} == 0 ]]; then
        RVAL="SUCCESS"
        BG_COLOR="beautiful.bg_normal"
        FG_COLOR="beautiful.fg_normal"
    else
        RVAL="FAILURE"
        BG_COLOR="beautiful.bg_urgent"
        FG_COLOR="beautiful.fg_urgent"
    fi

    # compose the notification
    MESSAGE="naughty.notify({ \
                title   = \"Command completed on: \t\t${DATE}\", \
                text    = \"↪ ${LAST}\" .. newline .. \"${RVAL}\", \
                timeout = 0, \
                bg      = ${BG_COLOR},
                fg      = ${FG_COLOR},
            })"
    # send it to awesome
    echo ${MESSAGE} | awesome-client
}
