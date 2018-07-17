#!/usr/bin/env zsh
# contains my custom abbreviations, aliases, and functions

###############
# ABBREVIATIONS
###############
# https://github.com/smly/config/blob/master/.zsh/abbreviations.zsh

typeset -A abbrs
abbrs=(
    # git
    "gg"    "git status"
    "ga"    "git add"
    "gau"   "git add -u"
    "gaa"   "git add -A"
    "gc"    "git commit"
    "gco"   "git checkout"
    "gd"    "git diff"
    "gds"   "git diff --staged"
    "gb"    "git branch"
    "gl"    "git log"
    "gll"   "git log --graph --oneline --all --decorate -n 25"
    "glll"  "git log --graph --oneline --all --decorate"
    "gcb"   "git rev-parse --abbrev-ref HEAD"
)

# $private_abbrs can be defined before this runs to be included as well
if [ ! -z "${private_abbrs}" ]; then
    for k in "${(@k)private_abbrs}"; do
        abbrs+=($k $private_abbrs[$k])
    done
fi

# create aliases for the abbreviations too
for abbr in ${(k)abbrs}; do
   alias -g $abbr="${abbrs[$abbr]}"
done

magic-abbrev-expand() {
     local left prefix
     left=$(echo -nE "$LBUFFER" | sed -e "s/[_a-zA-Z0-9]*$//")
     prefix=$(echo -nE "$LBUFFER" | sed -e "s/.*[^_a-zA-Z0-9]\([_a-zA-Z0-9]*\)$/\1/")
     LBUFFER=$left${abbrs[$prefix]:-$prefix}" "
}

no-magic-abbrev-expand() {
    LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
# space will magically expand abbrev
bindkey   " "    magic-abbrev-expand
# ctrl-x will prevent expansion
bindkey   "^x "  no-magic-abbrev-expand


#########
# ALIASES
#########

# external
source $(which virtualenvwrapper_lazy.sh)

# my aliases
alias cll="clear; ll"
alias grip="grep -i"
alias javarepl="java -jar /opt/javarepl.jar"
alias mylsblk="lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL"
# OSX compatible copy/paste
alias pbcopy="xclip -selection c"
alias pbpaste="xclip -selection clipboard -o"
alias psg="ps -ef | grep"
alias pubip="curl http://canihazip.com/s/; echo ''"
alias pyjson="python -m json.tool"
alias reload="source ~/.zshrc"
alias xo="xdg-open"

###########
# FUNCTIONS
###########

# awesome notification
# https://www.reddit.com/r/awesomewm/comments/1gyt8x/notifications_for_completed_commands/
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

function blog() {
    local bl_log_base="${HOME}/s3/bl-log"
    if [ $# -ne 1 ]; then
        echo "usage: blog [ASG]"
        return 1
    fi
    local asg="${1}"
    local bl_log_path="${bl_log_base}/${asg}"

    if [ ! -d "${bl_log_path}" ]; then
        mkdir -pv "${bl_log_path}"
    fi

    cd "${bl_log_path}"
}

function byedesk() {
    xrandr --output eDP1 --mode 1920x1080
    xrandr --output DP1 --off
}

# cd into last item in current directory
function cdlast() {
    last=$(ls -d */ | tail -1)
    cd ${last}
}

# finds dirty git repos
# uses $PWD or the 1st argument given as the root to look through
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

function hidesk() {
    xrandr --output eDP1 --off  --output DP1 --auto
}

function notes() {
    terminal_velocity "${NOTES}"
}

# resets the current virtual environment
function reset_virtualenv() {
    local venv
    if [ $# -gt 0 ]; then
        venv="/home/whw/.virtualenvs/${1}"
    else
        if [ -z "${VIRTUAL_ENV}" ]; then
            echo "ERROR: needs active virtualenv, or one passed as a parameter"
            return 1
        fi
        venv="${VIRTUAL_ENV}"
    fi
    local venv_name=$(basename ${venv})

    if [ ! -d "${venv}" ]; then
        echo "ERROR: could not find ${venv}"
        return 1
    fi

    # deactivate if virtualenv is active
    if [ ! -z "${VIRTUAL_ENV}" ]; then
        deactivate
    fi

    # python2 prints version to stderr but python3 uses stdout
    python_version=$(${venv}/bin/python --version 2>&1 | sed 's/Python //')

    local python_interp
    # right now only supporting python 2 vs 3
    if [ "${python_version:0:1}" = "2" ]; then
        python_interp=$(which python2)
    elif [ "${python_version:0:1}" = "3" ]; then
        python_interp=$(which python3)
    else
        echo "ERROR: invalid python version? ${python_version}"
        return 1
    fi

    rmvirtualenv ${venv_name}
    mkvirtualenv ${venv_name} --python ${python_interp}
}

function rgnotes() {
    rg "$@" ${NOTES}
}

function shrug() {
    echo -n "¯\_(ツ)_/¯"
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
