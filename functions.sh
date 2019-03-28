#!/bin/bash

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
