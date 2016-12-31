#!/bin/bash
# setup linux dependencies

DEPENDS=("vim" "git" "curl" "zsh" "jq" "tree" "awscli" "tmux" "xclip" "terminator")
DEPENDS+=("acpi" "xbacklight" "xautolock")  # awesome
DEPENDS+=("openssh-client" "openssh-server")  # ssh
DEPENDS+=("dmsetup")  # truecrypt

sudo apt-get update
sudo apt-get install -y "${DEPENDS[@]}"
