#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
source lib.sh

# CLI args/options
ARGS=()
DRY_RUN=false

print_usage() {
    echo "Usage: install-v2.sh [OPTION]..."
    echo ""
    echo "Options:"
    printf "    %-20s print this message and exit\n" "-h, --help"
    printf "    %-20s outputs the operations that would run, but does not run them\n" "--dry-run"
}

while [[ $# -gt 0 ]]; do
    case ${1} in
        -h|--help)
            print_usage
            exit 0
            ;;
        --dry-run)
            DRY_RUN=true
            ;;
        *)
            ARGS+=("${1}")
        ;;
    esac
    shift # past argument or value
done

install_packages() {
    info "Installing packages..."
    case "$(uname -s)" in
        Linux)
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
            ;;
        Darwin)
            ensure_homebrew
            brew install \
                coreutils \
                findutils \
                gnu-tar \
                jq \
                pipx \
                tmux \
                tree \
                neovim \
                stow
            brew install --cask \
                karabiner-elements \
                sensiblesidebuttons
            ;;
        *)
            fail "Unsupported OS: $(uname -s)"
            exit 1
            ;;
    esac
}


main() {
    info "Setting up dotfiles v2!"

    info "Updating submodules"
    git submodule init
    git submodule update

    install_packages

    info "Installing dotfiles..."

    if ! type stow > /dev/null; then
        fail "stow is not installed"
        exit 1
    fi

    # TODO: do I need support for "restow" or "adopt" ?
    if [[ ${DRY_RUN} == true ]]; then
        stow --simulate -v .
    else
        stow -v .
    fi
}

main "$@"

