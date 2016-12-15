#!/usr/bin/env zsh
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

function get_prompt() {
    printf "%s@%s" $(whoami) $(hostname)
    echo
    echo -n "%"
    printf '↪ '
}

PROMPT="$(get_prompt)"
RPS1="%B${return_code}%b"
