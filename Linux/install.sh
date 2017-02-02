#!/bin/bash
# setup linux dependencies

sudo apt-get update
sudo apt-get install -y "vim" "git" "curl" "zsh" "jq" "tree" "awscli" "tmux" "xclip" "terminator" \
                        "acpi" "xbacklight" "xautolock" \
                        "openssh-client" "openssh-server" \
                        "dmsetup"

