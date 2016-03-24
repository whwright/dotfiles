#!/bin/sh
# Setup Sublime Text 3

. functions.sh

info "running sublime3/install.sh"

if [ `uname -s` == 'Darwin' ]
then
    sublime_dir=~/Library/Application\ Support/Sublime\ Text\ 3/Packages
else
    fail "unsupported operating system"
fi

mv "$sublime_dir/User" "$sublime_dir/User.backup"
ln -s ~/.dotfiles/sublime3/User "$sublime_dir"