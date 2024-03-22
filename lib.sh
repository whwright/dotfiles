#!/usr/bin/env bash

info() {
    printf "  [ \033[00;34m..\033[0m ] $1\n"
}
export -f info

question() {
    printf "\r  [ \033[0;33m??\033[0m ] $1 "
}
export -f question

success() {
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}
export -f success

fail() {
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
}
export -f fail

skipped() {
    printf "  [ -- ] $1\n"
}
export -f skipped

contains_element() {
    local e match="${1}"
    shift
    for e; do [[ "${e}" == "${match}" ]] && return 0; done
    return 1
}
export -f contains_element

ensure_homebrew() {
    if ! type brew > /dev/null ; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}
