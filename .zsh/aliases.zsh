#!/usr/bin/env zsh
# aliases!

# my aliases
alias grip="grep -i"
alias ls="gls --color=tty"
alias ll="ls -lhN"
alias la="ls -lAhN"
alias psg="ps -ef | grep"
alias rg="rg --hidden"
alias strip-colors='sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g"'

# TMUX (taken from tmux.plugin.zsh)
alias tl="tmux list-sessions"
alias tkss="tmux kill-session -t"
alias ts="tmux new-session -d -s"

if [ "$(uname -s)" = "Darwin" ]; then
    alias xo="open"
elif [ "$(uname -s)" = "Linux" ]; then
    alias mylsblk="lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL"
    # OSX compatible copy/paste
    alias pbcopy="xclip -selection c"
    alias pbpaste="xclip -selection clipboard -o"
    alias resetaudio="pulseaudio --kill && pulseaudio --start"
    alias xo="xdg-open"
fi

lazy_load() {
    # Stolen/modified from https://gist.github.com/QinMing/364774610afc0e06cc223b467abe83c0
    # Act as a stub to another shell function/command. When first run, it will load the actual
    # function/command then execute it.
    # $1: space separated list of alias to release after the first load
    # $2: function/command to execute on load
    # $3: name of the command to run after it's loaded
    # $4+: argv to be passed to $3
    # Example: `alias ruby="lazy_load 'ruby' _rbenv_load ruby"`
    local names=("${(@s: :)${1}}")
    local func="${2}"

    unalias "${names[@]}"
    ${2}
    shift 2
    $*
}

group_lazy_load() {
    # Example: `group_lazy_load _load_nvm nvm node npm`
    local func="${1}"
    shift 1
    for cmd in "$@"; do
        alias ${cmd}="lazy_load \"$*\" ${func} ${cmd}"
    done
}
