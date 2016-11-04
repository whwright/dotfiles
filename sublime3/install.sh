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
fi

if [ ! -L "${SUBLIME_DIR}/Packages/User" ]; then
    mv "${SUBLIME_DIR}/Packages/User" "${SUBLIME_DIR}/Packages/User.backup"
    ln -s ~/.dotfiles/sublime3/User "${SUBLIME_DIR}/Packages/User"

    if [ "${UNAME}" == "Darwin" ] && [ ! -L /usr/local/bin/subl ]; then
        ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/
    fi

    # install package control
    if [ ! -d "${SUBLIME_DIR}/Installed Packages" ]; then
        mkdir -p "${SUBLIME_DIR}/Installed Packages"
    fi
    curl --silent --show-error \
        -o "${SUBLIME_DIR}/Installed Packages/Package Control.sublime-package" \
        https://packagecontrol.io/Package%20Control.sublime-package

    success "sublime3 installed"
else
    info "sublime3 already installed"
fi
