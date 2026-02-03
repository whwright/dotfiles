#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
source lib.sh

# Only update homebrew every 24h
export HOMEBREW_AUTO_UPDATE_SECS="86400"

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

    if [ ${DRY_RUN} == true ]; then
        skipped "skipping packages"
        return 0
    fi

    case "$(uname -s)" in
        Linux)
            sudo apt-get -qq update
            sudo apt-get -qq install -y \
                build-essential \
                curl \
                fzf \
                git \
                jq \
                mkvtoolnix \
                neovim \
                pipx \
                ripgrep \
                stow \
                tmux \
                tree \
                vim \
                xclip \
                zsh
            ;;
        Darwin)
            ensure_homebrew
            brew install \
                coreutils \
                findutils \
                fzf \
                gnu-tar \
                jq \
                n \
                neovim \
                pipx \
                ripgrep \
                stow \
                tmux \
                tree \
                wezterm \
                zsh
            brew install --cask \
                karabiner-elements \
                sensiblesidebuttons
            ;;
        *)
            fail "Unsupported OS: $(uname -s)"
            exit 1
            ;;
    esac
    success "Done installing packages"
}

run_script() {
    local script="${1}"
    if [ -z "${script}" ]; then
        fail "Invalid script: ${script}"
        return 1
    fi

    local msg="running ${script}"
    if [ ${DRY_RUN} == true ]; then
        skipped "${msg}"
        return
    fi

    info "${msg}"
    ${script}
    if [ ! $? -eq 0 ]; then
        fail "${script} failed"
    else
        success "${script} finished"
    fi
}

install_scripts() {
    info "Running install scripts..."
    find_func=$(which gfind || which find)
    for install_script in $(${find_func} scripts/ -type f -executable | sort); do
        run_script "${install_script}"
    done
    success "Done running install scripts"
}

load_gnome_configs() {
    # Helpful things
    # find keybinds
    # gsettings list-recursively | grep -i "'<Super><Alt>"
    info "Loading gnome configs"
    GNOME_DIR="$(dirname "$0")/gnome"

    if [ "$XDG_CURRENT_DESKTOP" != "GNOME" ]; then
        fail "Skipping GNOME keybindings: not running GNOME (detected: $XDG_CURRENT_DESKTOP)"
        return 0
    fi

    # media-keys.dconf: Custom keyboard shortcuts (e.g., rofi launcher, app launchers)
    dconf load /org/gnome/settings-daemon/plugins/media-keys/ < "$GNOME_DIR/media-keys.dconf"

    # wm-keybindings.dconf: Window manager shortcuts (e.g., workspace switching, window movement)
    # if keybinds look like org.gnome.desktop.wm.keybindings
    dconf load /org/gnome/desktop/wm/keybindings/ < "$GNOME_DIR/wm-keybindings.dconf"

    # shell.dconf: GNOME Shell keybindings (e.g., screenshot, overview toggle)
    # if keybinds look like org.gnome.shell.keybindings
    dconf load /org/gnome/shell/keybindings/ < "$GNOME_DIR/shell.dconf"

    # Other keybind options that claude said I may want in the future
    # mutter.dconf: Compositor settings (e.g., overlay key, edge tiling)
    # dconf load /org/gnome/mutter/ < "$GNOME_DIR/mutter.dconf"

    # gtile.dconf: gtile extension configuration for snapping windows
    dconf load /org/gnome/shell/extensions/gtile/ < "$GNOME_DIR/gtile.dconf"
}


main() {
    info "Setting up dotfiles v2!"

    info "Updating submodules"
    git submodule init
    git submodule update

    install_packages
    install_scripts

    info "Installing dotfiles..."

    if ! type stow > /dev/null; then
        fail "stow is not installed"
        exit 1
    fi

    if [[ ${DRY_RUN} == true ]]; then
        stow --simulate -v .
    else
        stow -v .
    fi

    if [ "$(uname -s)" = "Linux" ]; then
        load_gnome_configs
    fi

    success "Done! Great job."
}

main "$@"

