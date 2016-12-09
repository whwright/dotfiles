#!/usr/bin/env fish
# fish config for Linux

# setup local python PATH before calling common config
set -x PATH $PATH ~/.local/bin

. ~/.config/fish/common.fish
if test -e ~/.config/fish/vandelay.fish
    . ~/.config/fish/vandelay.fish
end

# OSX compatible copy/paste
alias pbcopy "xclip -selection c"
alias pbpaste "xclip -selection clipboard -o"

eval (dircolors -c $HOME/.dircolors/256dark)

# java
set -l MY_JAVA_HOME "/usr/lib/jvm/java-1.7.0-openjdk-amd64"
if test -d $MY_JAVA_HOME
    set -x JAVA_HOME $MY_JAVA_HOME
else
    echo "WARNING: invalid JAVA_HOME: $MY_JAVA_HOME"
end

# golang
if type go > /dev/null
    set -x PATH $PATH /usr/local/go/bin
    set -x GOPATH ~/Dev/go
    set -x PATH $PATH $GOPATH/bin
else
    echo "WARNING: go not installed"
end

