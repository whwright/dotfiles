#!/bin/bash
# setup linux dependencies

set -o errexit
set -o nounset
set -o pipefail
. functions.sh

sudo apt-get update
sudo apt-get install -y "vim" "git" "curl" "jq" "tree" "awscli" "tmux" "xclip" "terminator" \
                        "acpi" "xbacklight" "xautolock" \
                        "openssh-client" "openssh-server" \
                        "dmsetup"

