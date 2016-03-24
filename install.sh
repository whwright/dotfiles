#!/bin/bash
# my alteration of https://github.com/mossberg/dotfiles to work for my config on linux and osx

DOTFILES_ROOT="`pwd`"
# get inverse of uname so we don't install those files
if [ `uname -s` == "Linux" ]
then
    NOT_UNAME="Darwin"
else
    NOT_UNAME="Linux"
fi

set -e

info() {
    printf "  [ \033[00;34m..\033[0m ] $1"
    echo ""
}

user() {
    printf "\r  [ \033[0;33m?\033[0m ] $1 "
}

success() {
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail() {
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
    echo ""
    exit
}

link_files() {
    ln -s $1 $2
    success "linked $1 to $2"
}

link_fish_functions() {
    for source in `find $DOTFILES_ROOT/fish/functions/*.fish`
    do
        DARWIN_DST="$DOTFILES_ROOT/Darwin/fish/config.symlink/fish/functions/`basename $source`"
        if [ -f $DARWIN_DST ]
        then
            rm $DARWIN_DST
        fi
        ln -s $source $DARWIN_DST

        LINUX_DST="$DOTFILES_ROOT/Linux/fish/config.symlink/fish/functions/`basename $source`"
        if [ -f $LINUX_DST ]
        then
            rm $LINUX_DST
        fi
        ln -s $source $LINUX_DST
    done
}

install_dotfiles() {
    echo ""
    info "installing dotfiles"

    overwrite_all=false
    backup_all=false
    skip_all=false

    for source in `find $DOTFILES_ROOT -name \*.symlink -not -path "$DOTFILES_ROOT/$NOT_UNAME/*"`
    do
        dest="$HOME/.`basename \"${source%.*}\"`"

        if [ `basename $dest` == ".config" ]
        then
            item_name=`ls $source | head -1`
            source="$source/$item_name"
            dest="$dest/$item_name"

            user "Changed source to $source and dest to $dest - continue (y/n)?"
            read -p "" action
            case "$action" in
                y|Y)
                    ;;
                n|N )
                    continue;;
                *)
                    info "invalid - skipping"
                    continue
                    ;;
            esac
        fi

        if [ -f $dest ] || [ -d $dest ]
        then

            overwrite=false
            backup=false
            skip=false

            if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
            then
                user "File already exists: `basename $source`, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
                read -p "" action

                case "$action" in
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


            if [ "$overwrite" == "true" ] || [ "$overwrite_all" == "true" ]
            then
                rm -rf $dest
                success "removed $dest"
            fi

            if [ "$backup" == "true" ] || [ "$backup_all" == "true" ]
            then
                mv $dest $dest\.backup
                success "moved $dest to $dest.backup"
            fi

            if [ "$skip" == "false" ] && [ "$skip_all" == "false" ]
            then
                link_files $source $dest
            else
                success "skipped $source"
            fi
        else
            link_files $source $dest
        fi

    done

    info "done with dotfiles"
}

run_install_scripts() {
    echo ""
    info "running install scripts"
}

link_fish_functions
install_dotfiles
run_install_scripts
