#!/bin/bash

source functions.sh

ARGS=()
DOTFILES_ROOT=${PWD}
DRY_RUN=false
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

while [[ $# -gt 0 ]]; do
    case ${1} in
        -h|--help)
            echo "Usage: install.sh [OPTION]..."
            echo ""
            echo "Options:"
            echo "    -h, --help        print this message and exit"
            echo "    --dry-run         outputs the operations that would run, but does not run them"
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

# Helper functions we want to export downstream
info() {
    printf "  [ \033[00;34m..\033[0m ] $1\n"
}
export -f info

question() {
    printf "\r  [ \033[0;33m??\033[0m ] $1 "
}
export -f question

success() {
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}
export -f success

fail() {
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
}
export -f fail

skipped() {
    printf "  [ -- ] $1\n"
}
export -f skipped
# End helper functions

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

    ${cmd_prefix} rm "${dst}"
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
        # Currently these cases are ~/.config and ~/.ssh
        # TODO: there's probably a better way to do this
        if [ $(basename ${dest}) == ".config" ] || [ $(basename ${dest}) == ".ssh" ]; then
            if [ $(ls ${item} | wc -l) != 1 ]; then
                # TODO: this will probably need to change as the pattern is no longer _only_ ~/.config
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

    for install_script in $(find ${DOTFILES_ROOT} -mindepth 2 -maxdepth 2 -name install.sh); do
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
    info "Setting up dotfiles!"

    # info "Updating submodules"
    git submodule init
    git submodule update

    get_private_scripts

    # # run install scripts first since they might install dependencies needed
    run_install_scripts
    install_dotfiles

    link_files "${DOTFILES_ROOT}/bin"
    link_files "${PRIVATE_SCRIPTS_ROOT}"

    # # extra steps that aren't generic
    # # TODO: revist this?
    run_script "${PWD}/fzf/fzf.symlink/install --completion --key-bindings --no-update-rc --no-fish"
}

main "$@"
