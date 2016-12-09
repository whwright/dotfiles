#!/bin/bash
# Setup Sublime Text 3

. functions.sh

UNAME=$(uname -s)

if [ "${UNAME}" == "Darwin" ]; then
    SUBLIME_DIR=~/Library/Application\ Support/Sublime\ Text\ 3
elif [ "${UNAME}" == "Linux" ]; then
    SUBLIME_DIR=~/.config/sublime-text-3
else
    fail "unsupported operating system"
    exit 1
fi

if [ ! -L "${SUBLIME_DIR}/Packages/User" ]; then
    info "installing sublime3 config"
    mv "${SUBLIME_DIR}/Packages/User" "${SUBLIME_DIR}/Packages/User.backup"
    ln -s ~/.dotfiles/sublime3/User "${SUBLIME_DIR}/Packages/User"

    if [ "${UNAME}" == "Darwin" ] && [ ! -L /usr/local/bin/subl ]; then
        ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/
    fi
    success "sublime3 config installed"
else
    info "sublime3 config already installed"
fi


# install package control
if [ ! -d "${SUBLIME_DIR}/Installed Packages" ]; then
    mkdir -p "${SUBLIME_DIR}/Installed Packages"
fi
info "installing package control"
curl --silent --show-error \
    -o "${SUBLIME_DIR}/Installed Packages/Package Control.sublime-package" \
    https://packagecontrol.io/Package%20Control.sublime-package
