#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
source lib.sh

install_ripgrep() {
    info "Installing ripgrep..."
    case "$(uname -s)" in
        Linux)
            DEB_FILE_URL="https://github.com/BurntSushi/ripgrep/releases/download/11.0.1/ripgrep_11.0.1_amd64.deb"
            DEST="/tmp/$(basename ${DEB_FILE_URL})"
            curl --silent --show-error -o "${DEST}" -L "${DEB_FILE_URL}"
            sudo dpkg -i "${DEST}"
            ;;
        Darwin)
            brew install ripgrep
            ;;
        *)
            fail "Unsupported OS: $(uname -s)"
            exit 1
            ;;
    esac
}

# install zsh
if ! type rg > /dev/null 2>&1; then
    install_ripgrep
else
    info "ripgrep already installed"
fi
