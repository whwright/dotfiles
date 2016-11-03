#!/bin/bash

info() {
    printf "  [ \033[00;34m..\033[0m ] $1"
    echo "" # idk wht I need this
}

user() {
    printf "\r  [ \033[0;33m?\033[0m ] $1 "
}

success() {
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail() {
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
    echo ""
}

link_file() {
    if [ -f $2 ]; then
        rm $2
    fi

    if [ "$3" == "--root" ]; then
        sudo ln -s $1 $2
    else
        ln -s $1 $2
    fi
    success "linked $1 to $2"
}