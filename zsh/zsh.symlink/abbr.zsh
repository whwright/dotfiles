#!/usr/bin/env zsh
# expandable abbreviations config

# https://github.com/smly/config/blob/master/.zsh/abbreviations.zsh
typeset -A abbreviations
abbreviations=(
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

# create aliases for the abbreviations too
for abbr in ${(k)abbreviations}; do
   alias -g $abbr="${abbreviations[$abbr]}"
done

magic-abbrev-expand() {
     local left prefix
     left=$(echo -nE "$LBUFFER" | sed -e "s/[_a-zA-Z0-9]*$//")
     prefix=$(echo -nE "$LBUFFER" | sed -e "s/.*[^_a-zA-Z0-9]\([_a-zA-Z0-9]*\)$/\1/")
     LBUFFER=$left${abbreviations[$prefix]:-$prefix}" "
}

no-magic-abbrev-expand() {
    LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
bindkey   " "    magic-abbrev-expand
bindkey   "^x "  no-magic-abbrev-expand
