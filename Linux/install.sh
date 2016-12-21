#!/bin/bash
# setup linux dependencies

. functions.sh
DOTFILES_ROOT="$(pwd)"

sudo apt-get update
sudo apt-get install -y vim git curl zsh jq tree awscli tmux xclip \
                        terminator \
                        acpi \
                        openssh-client openssh-server \
                        dmsetup
