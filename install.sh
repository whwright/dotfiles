#!/bin/bash
# my alteration of https://github.com/mossberg/dotfiles to work for my config on linux and osx

# TODO: consider removing this, not using OSX anymore
# how Linux vs Darwin works
# files/folders named {name}.symlink will be linked to ~/.{name}
# files/folders that exist in dotfiles/Linux or dotfiles/Darwin will only be linked on linux and OSX respectively
# the same applies to */install.sh

. functions.sh

DOTFILES_ROOT=${PWD}
UNAME=$(uname -s)
# get inverse of uname so we don't install those files
if [ ${UNAME} == "Linux" ]; then
    NOT_UNAME="Darwin"
elif [ ${UNAME} == "Darwin" ]; then
    NOT_UNAME="Linux"
else
    fail "Unknown uname ${UNAME}"
    exit 1
fi

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

    for item in $(find ${DOTFILES_ROOT} -name \*.symlink -not -path "${DOTFILES_ROOT}/${NOT_UNAME}/*" -not -path "${DOTFILES_ROOT}/.git/*"); do
        if [ "${skip_all}" == "true" ]; then
            success "skipped ${item}"
            continue
        fi

        dest="${HOME}/.$(basename ${item%.*})"

        if [ $(basename ${dest}) == ".config" ]; then
            if [ $(ls ${item} | wc -l) != 1 ]; then
                fail "Found more than 1 item in a nested config dir: ${item}"
                exit 2
            fi

            item_name=$(ls ${item})
            item="${item}/${item_name}"
            dest="${dest}/${item_name}"
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

    for install_script in $(find ${DOTFILES_ROOT} -mindepth 2 -maxdepth 2 -name install.sh); do
        # strip $PWD/ off the start of the script name to get a relative path
        # /home/whw/.dotfiles/javarepl/install.sh -> javarepl/install.sh
        # note: using '@' as a delimeter since slashes are in PWD
        rel_path=$(echo "${install_script}" | sed 's@'"${PWD}/"'@@')

        if [ "${rel_path:0:5}" == "Linux" ] && [ $(uname -s) != "Linux" ]; then
            continue
        elif [ "${rel_path:0:6}" == "Darwin" ] && [ $(uname -s) != "Darwin" ]; then
            continue
        fi

        info "running ${rel_path}"
        ${install_script}
        if [ ! $? -eq 0 ]; then
            fail "${install_script} failed"
        else
            info "${rel_path} finished"
        fi
    done

    info "done with install scripts"
}

link_bin_files() {
    # link files from dotfiles/bin to /usr/local/bin and
    # deletes dead links in /usr/local/bin
    BIN="${DOTFILES_ROOT}/bin"
    if [ -d "${BIN}" ]; then
        echo ""
        info "linking bin files"
        for item in $(find ${BIN} -type f); do
            link_file ${item} "/usr/local/bin/$(basename ${item})" --root
        done
    else
        info "bin directory does not exist"
    fi

    # find broken symlinks if a binary is removed or renamed
    for item in $(find /usr/local/bin/ -xtype l); do
        info "removing dead symlink: ${item}"
        sudo rm ${item}
    done
 }

 main() {
    # update submodules first
    git submodule init
    git submodule update

    # run install scripts first since they might install dependencies needed
    run_install_scripts
    install_dotfiles
    link_bin_files
 }

main "$@"
