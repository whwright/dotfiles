#!/bin/bash
# my alteration of https://github.com/mossberg/dotfiles to work for my config on linux and osx

print_usage() {
    echo "Usage: install.sh [OPTIONS]"
    echo ""
    echo "Install dotfiles"
    echo "Options:"
    echo "  --dotfiles                   install dotfiles"
    echo "  --installers                 run install.sh scripts"
    echo "  --bin                        link files in dotfiles/bin"
    echo "  --installer [INSTALLER]      specify installer to fun"
    echo "  --all                        install everything"
}

ARGS=()
INSTALL_DOTFILES=false
RUN_INSTALL_SCRIPTS=false
LINK_BIN_FILES=false
INSTALLER=false

while [[ $# -gt 0 ]]; do
    key="${1}"
    case ${key} in
        -h|--help)
            print_usage
            exit 0
            ;;
        --all)
            INSTALL_DOTFILES=true
            RUN_INSTALL_SCRIPTS=true
            LINK_BIN_FILES=true
            ;;
        --dotfiles)
            INSTALL_DOTFILES=true
            ;;
        --installers)
            RUN_INSTALL_SCRIPTS=true
            ;;
        --installer)
            INSTALLER="$2"
            shift
            ;;
        --bin)
            LINK_BIN_FILES=true
            ;;
        *)
            ARGS+=("${key}")
        ;;
    esac
    shift # past argument or value
done

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

link_generic_fish() {
    # remove all symlinks in Darwin and Linux
    find "${DOTFILES_ROOT}/Darwin" "${DOTFILES_ROOT}/Linux" -type l -delete

    FUNCTION_LOC="fish/config.symlink/fish/functions"
    mkdir -p "${DOTFILES_ROOT}/Darwin/${FUNCTION_LOC}"
    mkdir -p "${DOTFILES_ROOT}/Linux/${FUNCTION_LOC}"

    # general functions
    for item in $(find ${DOTFILES_ROOT}/fish/functions/*.fish); do
        link_file ${item} "${DOTFILES_ROOT}/Darwin/${FUNCTION_LOC}/$(basename ${item})"
        link_file ${item} "${DOTFILES_ROOT}/Linux/${FUNCTION_LOC}/$(basename ${item})"
    done

    # general config
    for item in $(find $DOTFILES_ROOT/fish/*.fish); do
        link_file ${item} "${DOTFILES_ROOT}/Darwin/fish/config.symlink/fish/$(basename ${item})"
        link_file ${item} "${DOTFILES_ROOT}/Linux/fish/config.symlink/fish/$(basename ${item})"
    done

    if [ $(hostname) == "vandelay" ]; then
        link_file "${DOTFILES_ROOT}/Linux/vandelay.fish" "${DOTFILES_ROOT}/Linux/fish/config.symlink/fish/vandelay.fish"
    fi
}

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

        echo $local_path
        continue

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
}

if [ ${INSTALLER} != false ]; then
    if [ ! -e "${INSTALLER}/install.sh" ]; then
        echo "No installer for ${INSTALLER}"
        exit 3
    fi
    "${INSTALLER}/install.sh"
    exit 0
fi

if [ ${INSTALL_DOTFILES} == false ] && [ ${RUN_INSTALL_SCRIPTS} == false ] && [ ${LINK_BIN_FILES} == false ]; then
    echo "Nothing to install"
    print_usage
    exit 0
fi

if [ ${INSTALL_DOTFILES} == true ]; then
    link_generic_fish
    install_dotfiles
fi

if [ ${RUN_INSTALL_SCRIPTS} == true ]; then
    run_install_scripts
fi

if [ ${LINK_BIN_FILES} == true ]; then
    link_bin_files
fi

