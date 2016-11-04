#!/bin/bash
# Setup Sublime Text 3

. functions.sh

UNAME=$(uname -s)

if [ "${UNAME}" == "Darwin" ]; then
    sublime_dir=~/Library/Application\ Support/Sublime\ Text\ 3
elif [ "${UNAME}" == "Linux" ]; then
    sublime_dir=~/.config/sublime-text-3
else
    fail "unsupported operating system"
fi

if [ ! -L "$sublime_dir/Packages/User" ]; then
    mv "$sublime_dir/Packages/User" "$sublime_dir/Packages/User.backup"
    ln -s ~/.dotfiles/sublime3/User "$sublime_dir/Packages/User"
    if [ "${UNAME}" == "Darwin" ] && [ ! -L /usr/local/bin/subl ]; then
        ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/
    fi
    success "sublime3 installed"
else
    info "sublime3 already installed"
fi
