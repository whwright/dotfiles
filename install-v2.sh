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

install_stow() {
    if type stow > /dev/null 2>&1; then
        info "stow already installed"
        return 0
    fi

    info "Installing stow..."
    case "$(uname -s)" in
        Linux)
            fail "stow Linux install not implemented"
            exit 1
            ;;
        Darwin)
            ensure_homebrew
            brew install stow
            ;;
        *)
            fail "Unsupported OS: $(uname -s)"
            exit 1
            ;;
    esac
}


main() {
    info "Setting up dotfiles v2!"
    install_stow

    info "installing dotfiles"
    # TODO: do I need support for "restow" or "adopt" ?
    if [[ ${DRY_RUN} == true ]]; then
        stow --simulate -v .
    else
        stow -v .
    fi
}

main "$@"

