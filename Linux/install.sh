#!/bin/bash
# setup linux dependencies

. functions.sh
DOTFILES_ROOT="$(pwd)"

sudo apt-get update
sudo apt-get install vim git curl zsh jq tree awscli tmux xclip \
                     openssh-client openssh-server \
                     dmsetup
