#!/usr/bin/env fish
# fish config for Linux

# setup local python PATH before calling common config
set -x PATH $PATH ~/.local/bin

# set MY_JAVA_HOME before sourcing common
set -x MY_JAVA_HOME "/usr/lib/jvm/java-1.7.0-openjdk-amd64"

. ~/.config/fish/common.fish

# machine specific config
if test -e ~/.config/fish/vandelay.fish
    . ~/.config/fish/vandelay.fish
else if test -e ~/.config/fish/pennypacker.fish
    . ~/.config/fish/pennypacker.fish
end

# OSX compatible copy/paste
alias pbcopy "xclip -selection c"
alias pbpaste "xclip -selection clipboard -o"

eval (dircolors -c $HOME/.dircolors/256dark)
