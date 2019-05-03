#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
source lib.sh

install_zsh() {
    info "Installing zsh..."
    case "$(uname -s)" in
        Linux)
            sudo apt-get update \
                && sudo apt-get install zsh \
                && success "zsh installed"
            ;;
        Darwin)
            brew install zsh
            ;;
        *)
            fail "Unsupported OS: $(uname -s)"
            exit 1
            ;;
    esac
}

# install zsh
if ! type zsh > /dev/null; then
    install_zsh
else
    info "zsh already installed"
fi

# update zsh to default shell
if [ "$(basename ${SHELL})" != "zsh" ]; then
    info "Updating zsh to default shell..."
    chsh -s $(which zsh)
    success "Shell updated"
else
    info "zsh already default shell"
fi
