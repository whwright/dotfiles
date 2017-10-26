#!/usr/bin/env zsh

#######################
# ENVIRONMENT VARIABLES
#######################

# zsh history
HISTSIZE=100000
SAVEHIST=100000
HIST_IGNORE_SPACE=true
HIST_NO_STORE=true
HIST_NO_FUNCTIONS=true

export EDITOR='vim'
# reminants of trying to make alt-c include hidden directories
# export FZF_ALT_C_COMMAND="command find -L . -mindepth 1 \\( -path '*/\\.*' \
#                                                             -o -fstype 'sysfs' \
#                                                             -o -fstype 'devfs' \
#                                                             -o -fstype 'devtmpfs' \
#                                                             -o -fstype 'proc' \\) -prune -o -type d -print 2> /dev/null | cut -b3-"
# export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

######
# PATH
######

# function that only loads to path if the directory exists
function _safe_load_to_path() {
    local args=()
    local load_first=false

    while [[ $# -gt 0 ]]; do
        key=${1}
        case ${key} in
            --load-first)
                load_first=true
                ;;
            *)
                args+="${key}"
                ;;
        esac
        shift
    done

    local new_path_item=${args[1]}
    if [ -d ${new_path_item} ]; then
        if [ ${load_first} = true ]; then
            export PATH=${new_path_item}:${PATH}
        else
            export PATH=${PATH}:${new_path_item}
        fi
    fi
}

# my private scripts
_safe_load_to_path "${HOME}/.whwscripts"
_safe_load_to_path "${HOME}/.blscripts"
# programing language binary paths
_safe_load_to_path "/usr/local/go/bin"   # go
_safe_load_to_path "${HOME}/.local/bin"  # python
_safe_load_to_path "${HOME}/.cargo/bin"  # rust

#########
# ALIASES
#########

# external
eval "$(thefuck --alias)"

# my aliases
alias grip="grep -i"
alias psg="ps -ef | grep"
alias pubip="curl http://canihazip.com/s/; echo ''"
alias cll="clear; ll"
alias javarepl="java -jar /opt/javarepl.jar"
alias reload="source ~/.zshrc"
alias pyjson="python -m json.tool"
alias mylsblk="lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL"
alias xo="xdg-open"
# OSX compatible copy/paste
alias pbcopy="xclip -selection c"
alias pbpaste="xclip -selection clipboard -o"

##########
# KEYBINDS
##########

# keybind for KP_ENTER (https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=685511)
if (( ${+terminfo[kent]} )); then
    kent="${terminfo[kent]}"
else
    kent=$(TERM=xterm echoti kent 2>/dev/null)
    # If there is nothing in `$kent' yet, use "ESC O M", which is
    # what xterm and urxvt use.
    [[ -z "$kent" ]] && kent=$'\eOM'
fi
bindkey "$kent" accept-line
unset kent

bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

#############
# PROGRAMMING
#############

# golang
if type go > /dev/null; then
    export GOPATH="${HOME}/Dev/go"
    PATH=${PATH}:${GOPATH}/bin
else
    echo "WARNING: go not installed"
fi

# nvm
# Hacky nvm default. https://github.com/creationix/nvm/issues/860
# _safe_load_to_path --load-first "${HOME}/.nvm/versions/node/v0.12.9/bin"
# _safe_load_to_path --load-first "${HOME}/.nvm/versions/node/v4.4.4/bin"
_safe_load_to_path --load-first "${HOME}/.nvm/versions/node/v6.5.0/bin"
