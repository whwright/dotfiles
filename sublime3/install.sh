#!/bin/bash
# setup Sublime Text 3

set -o errexit
set -o nounset
set -o pipefail
source lib.sh

# TODO: it's actually sublime 4 now
# install sublime3 config
# TODO: on first install SUBLIME_DIR will not be defined because it's in zsh config
# TODO: need to install sublime and install package control first
if [ ! -L "${SUBLIME_DIR}/Packages/User" ]; then
    info "Installing sublime3 config..."
    mv "${SUBLIME_DIR}/Packages/User" "${SUBLIME_DIR}/Packages/User.backup"
    ln -s ~/.dotfiles/sublime3/User "${SUBLIME_DIR}/Packages/User"
    success "sublime3 config installed"
else
    info "sublime3 config already installed"
fi

if [ "$(uname -s)" == "Darwin" ] && [ ! -f /usr/local/bin/subl ]; then
    # TODO: use link_file
    info "Linking subl binary"
    sudo ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl
fi
