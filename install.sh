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

# Link all dotfiles!
# Links *.symlink files/directories to their designated path
#   dotfiles/vim/vimrc.symlink              -> ~/.vimrc
#   dotfiles/awesome/config.symlink/awesome -> ~/.config/awesome
install_dotfiles() {
    info "installing dotfiles"

    local overwrite_all=false
    local backup_all=false
    local skip_all=false

    for item in $(find ${DOTFILES_ROOT} -name \*.symlink -not -path "${DOTFILES_ROOT}/${NOT_UNAME}/*" -not -path "${DOTFILES_ROOT}/.git/*"); do
        if [ "${skip_all}" == "true" ]; then
            success "skipped ${item}"
            continue
        fi

        dest="${HOME}/.$(basename ${item%.*})"

        # There are a couple of cases where we want to nest the symlink so it doesn't clobber other files.
        # Currently this is only ~/.config
        if [ $(basename ${dest}) == ".config" ]; then
            if [ $(ls ${item} | wc -l) != 1 ]; then
                fail "Found more than 1 item in a nested thing dir: ${item}"
                exit 2
            fi

            item_name=$(ls ${item})  # get the thing under `config.symlink`
            item="${item}/${item_name}"  # append it to item
            dest="${dest}/${item_name}"  # update the destination
            info "Changed item to ${item} and dest to ${dest}"
        fi

        if [ -f ${dest} ] || [ -d ${dest} ]; then
            overwrite=false
            backup=false
            skip=false

            if [ "${overwrite_all}" == "false" ] && [ "${backup_all}" == "false" ] && [ "${skip_all}" == "false" ]; then
                question "File already exists: $(basename ${item}), what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
                read -p "" action

                case "${action}" in
                    o )
                        overwrite=true;;
                    O )
                        overwrite_all=true;;
                    b )
                        backup=true;;
                    B )
                        backup_all=true;;
                    s )
                        skip=true;;
                    S )
                        skip_all=true;;
                    * )
                        ;;
                esac
            fi


            if [ "${overwrite}" == "true" ] || [ "${overwrite_all}" == "true" ]; then
                local msg="removed ${dest}"
                if [ ${DRY_RUN} == true ]; then
                    skipped "${msg}"
                else
                    rm -rf ${dest}
                    success "${msg}"
                fi
            fi

            if [ "${backup}" == "true" ] || [ "${backup_all}" == "true" ]; then
                local msg="moved ${dest} to ${dest}.backup"
                if [ ${DRY_RUN} == true ]; then
                    skipped "${msg}"
                else
                    mv ${dest} ${dest}\.backup
                    success "${msg}"
                fi
            fi

            if [ "${skip}" == "false" ] && [ "${skip_all}" == "false" ]; then
                link_file ${item} ${dest}
            else
                success "skipped ${item}"
            fi
        else
            link_file ${item} ${dest}
        fi

    done

    info "done with dotfiles"
}

# Run all scripts named "install.sh" at depth of 2
# Install scripts should be place in dotfiles/{module}/install.sh
# module=Linux will only run on Linux; module=Darwin will only run on OSX
run_install_scripts() {
    info "running install scripts"

    for install_script in $(find ${DOTFILES_ROOT} -mindepth 2 -maxdepth 2 -name install.sh | sort); do
        local module=${install_script#"${DOTFILES_ROOT}/"}  # trim off path prefix
        module=${module%"/install.sh"}  # trim off suffix

        if [ "${module}" == "${NOT_UNAME}" ]; then
            continue
        fi

        run_script "${install_script}"
    done

    info "done with install scripts"
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

# Link files from the given location to /usr/local/bin and deletes dead links
link_files() {
    local location="${1}"
    if [ -z "${location}" ]; then
        echo "location cannot be empty"
        exit 1
    fi

    info "linking bin files in ${location}"

    for item in $(find ${location} -type f -executable -not -iwholename '*.git*'); do
        link_file ${item} "/usr/local/bin/$(basename ${item})" --root
    done

    # find broken symlinks if a binary is removed or renamed
    for item in $(find /usr/local/bin/ -xtype l); do
        info "removing dead symlink: ${item}"
        if [ ${DRY_RUN} = false ]; then
            sudo rm ${item}
        fi
    done

    info "done"
}

get_private_scripts() {
    if [ ${DRY_RUN} = true ]; then
        info "skipping getting private scripts"
        return 0
    fi

    info "getting private scripts"

    if [ -d ${PRIVATE_SCRIPTS_ROOT} ]; then
        info "${PRIVATE_SCRIPTS_ROOT} already exists"
        pushd "${PRIVATE_SCRIPTS_ROOT}" > /dev/null

        if [[ $(git status --porcelain) ]]; then
            fail "private-scripts is dirty; fix this"
            exit 1
        fi

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

    info "done getting private scripts"
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

    # run install scripts first since they might install dependencies needed
    if contains_element "${INSTALL_SCRIPTS}" "${ARGS[@]}" || contains_element "${ALL}" "${ARGS[@]}"; then
        run_install_scripts
    fi

    if contains_element "${LINK_DOTFILES}" "${ARGS[@]}" || contains_element "${ALL}" "${ARGS[@]}"; then
        install_dotfiles

        # extra steps that aren't generic
        run_script "${DOTFILES_ROOT}/fzf/fzf.symlink/install --completion --key-bindings --no-update-rc --no-fish"
    fi

    if contains_element ${LINK_BINARIES} "${ARGS[@]}" || contains_element "${ALL}" "${ARGS[@]}"; then
        link_files "${DOTFILES_ROOT}/bin"

        get_private_scripts
        link_files "${PRIVATE_SCRIPTS_ROOT}"
    fi
}

main "$@"
