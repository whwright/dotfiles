. ~/.config/fish/common.fish

eval (dircolors -c $HOME/.dircolors/256dark)

set -x JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64

alias tcli "truecrypt-cli"
alias dlc "deluge-console"

# pyenv
set -x PATH ~/.pyenv/bin $PATH
status --is-interactive; and . (pyenv init -|psub)
status --is-interactive; and . (pyenv virtualenv-init -|psub)

