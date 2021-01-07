#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

sudo apt-get -qq update
sudo apt-get -qq install -y \
    curl \
    git \
    jq \
    mkvtoolnix \
    tmux \
    tree \
    vim \
    vim-gtk \
    xclip

# TODO: go through old packaages
# TODO: I think these 3 are from pennypacker/linux laptop
# acpi
# xbacklight
# xautolock
# TODO:
# openssh-client
# openssh-server
# dmsetup

