#!/bin/bash
# setup Sublime Text

set -o errexit
set -o nounset
set -o pipefail
source lib.sh

if [ "$(uname -s)" = "Darwin" ]; then
    SUBLIME_DIR="${HOME}/Library/Application Support/Sublime Text"
elif [ "$(uname -s)" = "Linux" ]; then
    SUBLIME_DIR="${HOME}/.config/sublime-text-3"
fi

if [[ ! -d "${SUBLIME_DIR}" ]]; then
    fail "Install Sublime Text and Package Control before running this script"
    exit 1
fi

if [ ! -L "${SUBLIME_DIR}/Packages/User" ]; then
    info "Installing sublime config..."
    mv "${SUBLIME_DIR}/Packages/User" "${SUBLIME_DIR}/Packages/User.backup"
    ln -s ~/.dotfiles/sublime/User "${SUBLIME_DIR}/Packages/User"
    success "sublime3 config installed"
else
    info "sublime3 config already installed"
fi

if [ "$(uname -s)" == "Darwin" ] && [ ! -f /usr/local/bin/subl ]; then
    info "Linking subl binary"
    sudo ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl
fi
