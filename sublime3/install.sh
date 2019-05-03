#!/bin/bash
# setup Sublime Text 3

set -o errexit
set -o nounset
set -o pipefail
source lib.sh

# TODO: assume sublime 3 is already installed?

UNAME=$(uname -s)

if [ "${UNAME}" == "Darwin" ]; then
    SUBLIME_DIR=~/Library/Application\ Support/Sublime\ Text\ 3
elif [ "${UNAME}" == "Linux" ]; then
    SUBLIME_DIR=~/.config/sublime-text-3
else
    fail "Unsupported operating system: ${UNAME}"
    exit 1
fi

# install sublime3 config
if [ ! -L "${SUBLIME_DIR}/Packages/User" ]; then
    info "Installing sublime3 config..."
    mv "${SUBLIME_DIR}/Packages/User" "${SUBLIME_DIR}/Packages/User.backup"
    ln -s ~/.dotfiles/sublime3/User "${SUBLIME_DIR}/Packages/User"
    success "sublime3 config installed"
else
    info "sublime3 config already installed"
fi

# install package control
DOWNLOAD_LINK="https://packagecontrol.io/Package%20Control.sublime-package"
INSTALL_LOC="${SUBLIME_DIR}/Installed Packages/Package Control.sublime-package"
if [ ! -f "${INSTALL_LOC}" ]; then
    info "Installing Package Control..."
    sudo curl --silent --show-error "${DOWNLOAD_LINK}" -o "${INSTALL_LOC}"
    success "Package Control installed"
else
    info "Package Control already intalled"
fi

if [ "${UNAME}" == "Darwin" ] && [ ! -f /usr/local/bin/subl ]; then
    # TODO: use link_file
    ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl
fi
