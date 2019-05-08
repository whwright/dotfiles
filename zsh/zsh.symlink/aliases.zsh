#!/usr/bin/env zsh
# aliases!

# my aliases
alias grip="grep -i"
alias ll="ls -lhN"
alias la="ls -lAhN"
alias psg="ps -ef | grep"
alias pyjson="python -m json.tool"
alias reload="source ~/.zshrc"

if [ "$(uname -s)" = "Darwin" ]; then
    alias xo="open"  # I'm too used to my own `xo`
elif [ "$(uname -s)" = "Linux" ]; then
    alias mylsblk="lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL"
    # OSX compatible copy/paste
    alias pbcopy="xclip -selection c"
    alias pbpaste="xclip -selection clipboard -o"
    alias xo="xdg-open"
fi

# external
source $(which virtualenvwrapper_lazy.sh)

# rbenv lazy load
# TODO: this could be made generic
if type rbenv > /dev/null; then
    function _rbenv_load {
        eval "$(rbenv init -)" > /dev/null 2>&1
    }

    _names=$(echo ~/.rbenv/shims/* | xargs -n 1 basename | sort | uniq | tr '\n' ' ')
    for name in $(echo ${_names}); do
        eval "function ${name} {
            unset -f ${_names} ; _rbenv_load ; ${name} \"\$@\"
        }"
    done

    unset _names
fi
