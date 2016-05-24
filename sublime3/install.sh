#!/bin/bash
# Setup Sublime Text 3

. functions.sh

info "running sublime3/install.sh"

if [ `uname -s` == 'Darwin' ]; then
    sublime_dir=~/Library/Application\ Support/Sublime\ Text\ 3/Packages
elif [ `uname -s` == "Linux" ]; then
    sublime_dir=~/.config/"sublime-text-3"
else
    fail "unsupported operating system"
fi

if [ ! -L "$sublime_dir/Packages/User" ]; then
    mv "$sublime_dir/Packages/User" "$sublime_dir/Packages/User.backup"
    ln -s ~/.dotfiles/sublime3/User "$sublime_dir/Packages"
    success "sublime3 installed"
else
    info "sublime3 already installed"
fi
