#!/bin/bash
# setup linux dependencies

. functions.sh
DOTFILES_ROOT="$(pwd)"

DEPENDS=("vim" "git" "curl" "zsh" "jq" "tree" "awscli" "tmux" "xclip" "terminator")
# awesome depends
DEPENDS+=("acpi" "xbacklight")
# ssh
DEPENDS+=("openssh-client" "openssh-server")
# truecrypt
DEPENDS+=("dmsetup")


sudo apt-get update
sudo apt-get install -y "${DEPENDS[@]}"
