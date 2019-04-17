#!/usr/bin/env bash

source lib.sh

DEB_FILE_URL="https://github.com/BurntSushi/ripgrep/releases/download/11.0.1/ripgrep_11.0.1_amd64.deb"
DEST="/tmp/$(basename ${DEB_FILE_URL})"

dpkg -l ripgrep > /dev/null
if [ $? -eq 0 ]; then
    info "ripgrep already installed"
    exit 0
fi

curl --silent --show-error -o "${DEST}" -L "${DEB_FILE_URL}"
sudo dpkg -i "${DEST}"

