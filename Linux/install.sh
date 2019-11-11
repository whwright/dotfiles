#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
source lib.sh

sudo apt-get -qq update
sudo apt-get -qq install -y "vim" "git" "curl" "jq" "tree" "awscli" "tmux" "xclip" "terminator" \
                        "acpi" "xbacklight" "xautolock" \
                        "openssh-client" "openssh-server" \
                        "dmsetup" "mkvtoolnix" "vim-gtk"

