. ~/.config/fish/common.fish

eval (dircolors -c $HOME/.dircolors/256dark)

set -l MY_JAVA_HOME "/usr/lib/jvm/java-1.7.0-openjdk-amd64"
if test -d $MY_JAVA_HOME
    set -x JAVA_HOME $MY_JAVA_HOME
else
    echo "WARNING: invalid JAVA_HOME: $MY_JAVA_HOME"
end

alias tcli "truecrypt-cli"
alias dlc "deluge-console"

# pyenv
set -x PATH $PATH ~/.pyenv/bin
status --is-interactive; and . (pyenv init -|psub)
status --is-interactive; and . (pyenv virtualenv-init -|psub)

# go
if type go > /dev/null
    set -x PATH $PATH /usr/local/go/bin
    set -x GOPATH ~/Dev/go
    set -x PATH $PATH $GOPATH/bin
else
    echo "WARNING: go not installed"
end
