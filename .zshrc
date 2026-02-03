#!/usr/bin/env zsh

# zsh history
HISTSIZE=100000
SAVEHIST=100000
HIST_IGNORE_SPACE=true
HIST_NO_STORE=true
HIST_NO_FUNCTIONS=true

export EDITOR='vim'
export HOMEBREW_AUTO_UPDATE_SECS="86400"

######
# PATH
######

export PATH=${PATH}:"${HOME}/.local/bin"
export PATH=${PATH}:"${HOME}/.pyenv/bin"
export PATH=${PATH}:"${HOME}/.poetry/bin"
export PATH=${PATH}:/usr/local/go/bin
export PATH=${PATH}:"${HOME}/Library/Application Support/JetBrains/Toolbox/scripts"
# TODO: This path changed on me and broke without me suspecting
export PATH="/opt/nvim-linux-x86_64/bin:${PATH}"
export PATH="/opt/homebrew/opt/postgresql@13/bin:$PATH"

##################
# EXTERNAL CONFIGS
# load first so they can be overriden by local configs
##################

[ -e /opt/homebrew/bin/brew            ] && eval "$(/opt/homebrew/bin/brew shellenv)"
[ -e "${HOME}/.zsh/direnv.zsh"         ] && source "${HOME}/.zsh/direnv.zsh"
# [ -e "${HOME}/.oh-my-zsh/oh-my-zsh.sh" ] && source "${HOME}/.oh-my-zsh/oh-my-zsh.sh"
[ -e "${HOME}/.cargo/env"              ] && source "${HOME}/.cargo/env"
# [ -e "$(which starship)"               ] && eval "$(starship init zsh)"

USE_NEW_STARSHIP_CONFIG=1
if [[ ${USE_NEW_STARSHIP_CONFIG} -eq 1 ]]; then
    eval "$(starship init zsh)"
    # TODO: cleanup but only source omz and not my whole (old) config
    ZSH=${HOME}/.oh-my-zsh
    source ${ZSH}/oh-my-zsh.sh
    unset LESS  # removes default `-R` option
else
    source "${HOME}/.zsh/oh-my-zsh.zsh"
fi

if [[ -e "$(which fzf)" ]]; then
    case "$(uname -s)" in
        Linux)
            source /usr/share/doc/fzf/examples/key-bindings.zsh
            source /usr/share/doc/fzf/examples/completion.zsh
            ;;
        Darwin)
            eval "$(fzf --zsh)"
            ;;
        *)
            fail "Unsupported OS: $(uname -s)"
            exit 1
            ;;
    esac
fi


mkdir -p $HOME/.n
export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$PATH

###############
# LOCAL CONFIGS
###############

[ -e "${HOME}/.zsh/$(hostname).zsh"   ] && source "${HOME}/.zsh/$(hostname).zsh"
[ -e "${HOME}/.zsh/abbreviations.zsh" ] && source "${HOME}/.zsh/abbreviations.zsh"
[ -e "${HOME}/.zsh/aliases.zsh"       ] && source "${HOME}/.zsh/aliases.zsh"
[ -e "${HOME}/.zsh/functions.zsh"     ] && source "${HOME}/.zsh/functions.zsh"
[ -e "${HOME}/.zsh/keybinds.zsh"      ] && source "${HOME}/.zsh/keybinds.zsh"
[ -e "${HOME}/.zsh/ssh.zsh"           ] && source "${HOME}/.zsh/ssh.zsh"
[ -e "${HOME}/.zsh/completions.zsh"   ] && source "${HOME}/.zsh/completions.zsh"
[ -e "${HOME}/.private.zsh"           ] && source "${HOME}/.private.zsh"

# TODO: do I need anything here for Linux to load dircolors?
if [[ "$(uname -s)" == "Darwin" ]] && type gdircolors &> /dev/null ; then
    eval "$(gdircolors)"
fi

# Could not get hyperlinks feature to startup inside omzsh plugin, so rolling my own here.
# Check out tmux.plugin.zsh to steal any more code
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux -T hyperlinks new-session
fi
