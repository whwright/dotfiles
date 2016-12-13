#!/bin/bash
# setup linux dependencies

. functions.sh
DOTFILES_ROOT="$(pwd)"

# install apt-get dependencies
APT_GET_DEPENDS=("vim" "git" "curl" "tree" "jq" "awscli" "tmux")
APT_GET_DEPENDS+=("xclip")
APT_GET_DEPENDS+=("openssh-client" "openssh-server")
APT_GET_DEPENDS+=("dmsetup")
sudo apt-get update
for ITEM in "${APT_GET_DEPENDS[@]}"; do
	echo "Installing ${ITEM}"
	sudo apt-get install -y "${ITEM}"
done
