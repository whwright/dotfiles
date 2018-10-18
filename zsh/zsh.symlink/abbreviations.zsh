#!/usr/bin/env zsh
# custom abbreviations
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
