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

    for item in $(find ${DOTFILES_ROOT} -name \*.symlink -not -path "${DOTFILES_ROOT}/${NOT_UNAME}/*"); do
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

    for install_script in $(find ${DOTFILES_ROOT} -name install.sh -not -path ${DOTFILES_ROOT}/install.sh); do
        local_path="$(basename $(dirname ${install_script}))/$(basename ${install_script})"

        if [ "${local_path:0:5}" == "Linux" ] && [ $(uname -s) != "Linux" ]; then
            continue
        elif [ "${local_path:0:6}" == "Darwin" ] && [ $(uname -s) != "Darwin" ]; then
            continue
        fi

        info "running ${local_path}"
        ${install_script}
        if [ ! $? -eq 0 ]; then
            fail "${install_script} failed"
        else
            info "${local_path} finished"
        fi
    done

    info "done with install scripts"
}

install_oh_my_zsh() {
    echo ""
    info "installing oh-my-zsh"
    OMZ_INSTALL_LOC="${HOME}/.oh-my-zsh"
    if [ -d ${OMZ_INSTALL_LOC} ]; then
        info "${OMZ_INSTALL_LOC} already exists"
    else
        git clone git://github.com/robbyrussell/oh-my-zsh.git ${OMZ_INSTALL_LOC}
    fi

    info "installing zsh-git-prompt"
    ZGP_INSTALL_LOC="${HOME}/.zsh-git-prompt"
    if [ -d ${ZGP_INSTALL_LOC} ]; then
        info "${ZGP_INSTALL_LOC} already exists"
    else
        git clone git@github.com:olivierverdier/zsh-git-prompt.git ${ZGP_INSTALL_LOC}
    fi

    # if [ "$(getent passwd "whw" | cut -d: -f7)" != "$(which zsh)" ]; then
    if [ "${SHELL}" != "$(which zsh)" ]; then
        chsh -s $(which zsh)
    fi
}

# run install scripts first since they might install dependencies needed
run_install_scripts
install_oh_my_zsh
install_dotfiles
