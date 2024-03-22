#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
source lib.sh

# Expect zsh to be installed, just set as default shell

if ! type zsh > /dev/null; then
    fail "ZSH not installed"
    exit 1
fi

# update zsh to default shell
if [ "$(basename ${SHELL})" != "zsh" ]; then
    info "Updating zsh to default shell..."
    chsh -s $(which zsh)
    success "Shell updated"
    info "you need to log out and back in for this change to be reflected"
else
    skipped "zsh already default shell"
fi
