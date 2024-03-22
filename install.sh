#!/bin/bash

source lib.sh

# CLI args
ARGS=()
DRY_RUN=false

# things to run
ALL="all"
LINK_DOTFILES="dotfiles"
INSTALL_SCRIPTS="scripts"
LINK_BINARIES="bin"
THINGS_TO_RUN=("${ALL}" "${LINK_DOTFILES}" "${INSTALL_SCRIPTS}" "${LINK_BINARIES}")

# constants
DOTFILES_ROOT=${PWD}
PRIVATE_SCRIPTS_ROOT="${HOME}/.private-scripts"
UNAME=$(uname -s)
# get inverse of uname so we don't install those files
if [ ${UNAME} == "Linux" ]; then
    NOT_UNAME="Darwin"
elif [ ${UNAME} == "Darwin" ]; then
    NOT_UNAME="Linux"
else
    fail "Unsupported OS: ${UNAME}"
    exit 1
fi

# Linux/OSX compat
find_func=$(which gfind || which find)

print_usage() {
    echo "Usage: install.sh [OPTION]... [THING TO RUN]..."
    echo ""
    echo "Things to run:"
    printf "    %-20s run everything\n" "${ALL}"
    printf "    %-20s link binaries\n" "${LINK_BINARIES}"
    printf "    %-20s link dotfiles/run related install scripts\n" "${LINK_DOTFILES}"
    printf "    %-20s run install scripts\n" "${INSTALL_SCRIPTS}"
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

link_file() {
    local src="${1}"
    local dst="${2}"
    # determine if we should run as root
    local cmd_prefix=""
    if [ "${3}" == "--root" ]; then
        cmd_prefix="sudo "
    fi

    if [ ${DRY_RUN} == true ]; then
        skipped "link ${src} to ${dst}"
        return 0
    fi

    if [ -e "${dst}" ]; then
        ${cmd_prefix} rm "${dst}"
    fi
    ${cmd_prefix} ln -s "${src}" "${dst}"
    success "linked $1 to $2"
}

# Run the given script; check return code; log success or failure
run_script() {
    local script="${1}"
    if [ -z "${script}" ]; then
     # || ! -f "${script}" ]; then
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

install_private_scripts() {
    if [ ${DRY_RUN} = true ]; then
        info "skipping getting private scripts"
        return 0
    fi

    info "installing private scripts"

    if [ -d ${PRIVATE_SCRIPTS_ROOT} ]; then
        info "${PRIVATE_SCRIPTS_ROOT} already exists"
        pushd "${PRIVATE_SCRIPTS_ROOT}" > /dev/null

        info "pulling latest from master"
        git pull origin master
        if [[ $(git status --porcelain) ]]; then
            fail "latest was not a clean pull"
            exit 1
        fi

        popd > /dev/null
    else
        git clone "git@github.com:whwright/scripts.git" ${PRIVATE_SCRIPTS_ROOT}
    fi

    pushd "${PRIVATE_SCRIPTS_ROOT}"
    make clean build
    if [[ $? -ne 0 ]]; then
        file "error building private scripts"
        info "continuing to linking.."
    fi

    info "installing private scripts"
    sudo make install
    if [[ $? -ne 0 ]]; then
        fail "error installing private scripts"
        return 0
    fi
    info "done installing private scripts"
}

main() {
    if [ ${#ARGS[@]} -eq 0 ]; then
        echo "Nothing to run!"
        print_usage
        return 1
    fi

    for arg in "${ARGS[@]}"; do
        if ! contains_element "${arg}" "${THINGS_TO_RUN[@]}"; then
            echo "${arg} is not a valid thing to run"
            print_usage
            return 1
        fi
    done

    info "Setting up dotfiles!"

    info "Updating submodules"
    git submodule init
    git submodule update

    mkdir -p "${HOME}/.config"
    if [[ ! -d /usr/local/bin ]]; then
        sudo mkdir -p /usr/local/bin
    fi

    if contains_element ${LINK_BINARIES} "${ARGS[@]}" || contains_element "${ALL}" "${ARGS[@]}"; then
        install_private_scripts
    fi
}

main "$@"
