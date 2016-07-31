. ~/.config/fish/common.fish
. ~/.config/fish/vandelay.fish

eval (dircolors -c $HOME/.dircolors/256dark)

set -x GOPATH ~/Dev/go
set -x PATH $GOPATH/bin $PATH
set -x JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

alias tcli "truecrypt-cli"
alias dlc "deluge-console"

# pyenv
set -x PATH "/home/wright8191/.pyenv/bin" $PATH
status --is-interactive; and . (pyenv init -|psub)
status --is-interactive; and . (pyenv virtualenv-init -|psub)

