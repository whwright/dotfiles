#!/usr/bin/env zsh
# aliases!

# my aliases
alias dkr="docker"
alias grip="grep -i"
alias ll="ls -lhN"
alias la="ls -lAhN"
alias psg="ps -ef | grep"
alias pyjson="python -m json.tool"

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

lazy_load() {
    # Stolen/modified from https://gist.github.com/QinMing/364774610afc0e06cc223b467abe83c0
    # Act as a stub to another shell function/command. When first run, it will load the actual
    # function/command then execute it.
    # $1: space separated list of alias to release after the first load
    # $2: function/command to execute on load
    # $3: name of the command to run after it's loaded
    # $4+: argv to be passed to $3
    # Example: `alias ruby="lazy_load 'ruby' _rbenv_load ruby"`
    local names=("${(@s: :)${1}}")
    local func="${2}"

    unalias "${names[@]}"
    ${2}
    shift 2
    $*
}

group_lazy_load() {
    # Example: `group_lazy_load _load_nvm nvm node npm`
    local func="${1}"
    shift 1
    for cmd in "$@"; do
        alias ${cmd}="lazy_load \"$*\" ${func} ${cmd}"
    done
}

# fuck
if type thefuck > /dev/null; then
    function _thefuck_load {
        eval "$(thefuck --alias)"
    }

    alias fuck="lazy_load 'fuck' _thefuck_load fuck"
fi

# rbenv
if type rbenv > /dev/null; then
    function _rbenv_load {
        eval "$(rbenv init -)" > /dev/null 2>&1
    }

    _names=$(echo ~/.rbenv/shims/* | xargs -n 1 basename | sort | uniq | tr '\n' ' ' | sed -e 's/[[:space:]]*$//')
    group_lazy_load _rbenv_load "${(@s: :)${_names}}"
    unset _names
fi

# sdkman
_sdkman_dir="${HOME}/.sdkman"
_sdkman_init_file="${_sdkman_dir}/bin/sdkman-init.sh"
if [ -s "${_sdkman_init_file}" ]; then
    function _sdkman_load {
        export SDKMAN_DIR="${_sdkman_dir}"
        source "${_sdkman_init_file}"
    }

    _names=$(echo ~/.sdkman/candidates/* | xargs -n 1 basename | sort | uniq | tr '\n' ' ' | sed -e 's/[[:space:]]*$//')
    _names+=("sdk")
    group_lazy_load _sdkman_load "${(@s: :)${_names}}"
    unset _names
fi
