#!/bin/bash
# my alteration of https://github.com/mossberg/dotfiles to work for my config on linux and osx

DOTFILES_ROOT=$(pwd)
UNAME=$(uname -s)
# get inverse of uname so we don't install those files
if [ ${UNAME} == "Linux" ]; then
    NOT_UNAME="Darwin"
elif [ ${UNAME} == "Darwin" ]; then
    NOT_UNAME="Linux"
else
    echo "Unknown uname ${UNAME}"
    exit 1
fi

. functions.sh

install_dotfiles() {
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
    echo ""
    info "running install scripts"

    for install_script in $(find ${DOTFILES_ROOT} -maxdepth 2 -name install.sh -not -path ${DOTFILES_ROOT}/install.sh); do
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

git submodule init
git submodule update

# run install scripts first since they might install dependencies needed
run_install_scripts
install_dotfiles
link_bin_files
