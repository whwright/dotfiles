#!/bin/bash

source functions.sh

PRIVATE_DOTFILES_CLONE_URL="git@github.com:whwright/private-dotfiles.git"
PRIVATE_DOTFILES_ROOT="${HOME}/.private-dotfiles"
DOTFILES_ROOT=${PWD}

ARGS=()
DRY_RUN=false
DEBUG_PRIVATE=false

while [[ $# -gt 0 ]]; do
    case ${1} in
        -h|--help)  # TODO: help message
            print_usage
            exit 0
            ;;
        --dry-run)
            DRY_RUN=true
            ;;
        --debug-private)
            DEBUG_PRIVATE=true
            ;;
        *)
            ARGS+=("${1}")
        ;;
    esac
    shift # past argument or value
done

link_file() {
    if [ ${DRY_RUN} = true ]; then
        success "skipped link $1 to $2"
        return 0
    fi

    # TODO: this function is ghetto
    if [ -f $2 ]; then
        if [ "$3" == "--root" ]; then
            sudo rm $2
        else
            rm $2
        fi
    fi

    if [ "$3" == "--root" ]; then
        sudo ln -s $1 $2
    else
        ln -s $1 $2
    fi
    success "linked $1 to $2"
}

install_dotfiles() {
    # link all dotfiles!
    # links *.symlink files/directories to their designated path
    # i.e. dotfiles/vim/vimrc.symlink              -> ~/.vimrc
    #      dotfiles/awesome/config.symlink/awesome -> ~/.config/awesome
    echo ""
    info "installing dotfiles"

    overwrite_all=false
    backup_all=false
    skip_all=false

    for item in $(find ${DOTFILES_ROOT} ${PRIVATE_DOTFILES_ROOT} -name \*.symlink -not -path "${DOTFILES_ROOT}/.git/*"); do
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
                fail "Found more than 1 item in a nested config dir: ${item}"
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
                user "File already exists: $(basename ${item}), what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
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
                rm -rf ${dest}
                success "removed ${dest}"
            fi

            if [ "${backup}" == "true" ] || [ "${backup_all}" == "true" ]; then
                mv ${dest} ${dest}\.backup
                success "moved ${dest} to ${dest}.backup"
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

run_install_scripts() {
    # runs all scripts named "install.sh" at a depth of 2
    # install scripts should be put at dotfiles/{module}/install.sh
    # i.e. dotfiles/Linux/install.sh
    echo ""
    info "running install scripts"

    for install_script in $(find ${DOTFILES_ROOT} ${PRIVATE_DOTFILES_ROOT} -mindepth 2 -maxdepth 2 -name install.sh); do
        if [ ${DRY_RUN} = true ]; then
            success "skipped ${install_script}"
            continue
        fi

        info "running ${install_script}"
        ${install_script}
        if [ ! $? -eq 0 ]; then
            fail "${install_script} failed"
        else
            success "${install_script} finished"
        fi
    done

    info "done with install scripts"
}

link_bin_files() {
    # link files from dotfiles/bin to /usr/local/bin and
    # deletes dead links in /usr/local/bin
    echo ""
    info "linking bin files"

    for item in $(find ${DOTFILES_ROOT}/bin ${PRIVATE_DOTFILES_ROOT}/bin -type f); do
        link_file ${item} "/usr/local/bin/$(basename ${item})" --root
    done

    # find broken symlinks if a binary is removed or renamed
    for item in $(find /usr/local/bin/ -xtype l); do
        info "removing dead symlink: ${item}"
        sudo rm ${item}
    done

    info "done"
}

get_private_dotfiles() {
    echo ""
    info "getting private dotfiles"

    if [ -d "${PRIVATE_DOTFILES_ROOT}" ]; then
        info "${PRIVATE_DOTFILES_ROOT} already exists"
        pushd "${PRIVATE_DOTFILES_ROOT}" > /dev/null

        if [[ $(git status --porcelain) ]]; then
            fail "private-dotfiles is dirty; fix this"
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
        git clone "${PRIVATE_DOTFILES_CLONE_URL}" "${PRIVATE_DOTFILES_ROOT}"
    fi

    info "done getting private dotfiles"
}

main() {
    # update submodules first
    git submodule init
    git submodule update

    if [ ${DEBUG_PRIVATE} = false ]; then
        get_private_dotfiles
    fi

    # run install scripts first since they might install dependencies needed
    run_install_scripts
    install_dotfiles
    link_bin_files

    # extra steps that aren't generic
    # TODO: revist this?
    link_file ${PWD}/autorandr/autorandr /usr/local/bin/autorandr --root
}

main "$@"
