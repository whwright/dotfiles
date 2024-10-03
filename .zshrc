#!/usr/bin/env zsh

# zsh history
HISTSIZE=100000
SAVEHIST=100000
HIST_IGNORE_SPACE=true
HIST_NO_STORE=true
HIST_NO_FUNCTIONS=true

export EDITOR='vim'

######
# PATH
######

export PATH=${PATH}:"${HOME}/.local/bin"
export PATH=${PATH}:"${HOME}/.pyenv/bin"
export PATH=${PATH}:"${HOME}/.poetry/bin"
export PATH=${PATH}:/usr/local/go/bin
export PATH=${PATH}:"${HOME}/Library/Application Support/JetBrains/Toolbox/scripts"

##################
# EXTERNAL CONFIGS
# load first so they can be overriden by local configs
##################

[ -e /opt/homebrew/bin/brew       ] && eval "$(/opt/homebrew/bin/brew shellenv)"
[ -e "${HOME}/.zsh/direnv.zsh"    ] && source "${HOME}/.zsh/direnv.zsh"
[ -e "${HOME}/.zsh/oh-my-zsh.zsh" ] && source "${HOME}/.zsh/oh-my-zsh.zsh"
[ -e "$(which fzf)"               ] && eval "$(fzf --zsh)"
[ -e "${HOME}/.ondir/scripts.zsh" ] && source "${HOME}/.ondir/scripts.sh"
[ -e "${HOME}/.cargo/env"         ] && source "${HOME}/.cargo/env"

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
[ -e "${HOME}/.private.zsh"           ] && source "${HOME}/.private.zsh"

# TODO: do I need anything here for Linux to load dircolors?
if [[ "$(uname -s)" == "Darwin" ]] && type gdircolors &> /dev/null ; then
    eval "$(gdircolors)"
fi

