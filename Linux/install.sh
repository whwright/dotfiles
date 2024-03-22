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
    neovim \
    pipx \
    tmux \
    tree \
    vim \
    vim-gtk \
    xclip
