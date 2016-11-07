#!/usr/bin/env fish
# fish config for OSX

# setup local python PATH before calling common config
set -x PATH ~/Library/Python/2.7/bin $PATH

. ~/.config/fish/common.fish
. ~/.config/fish/bl.fish
. ~/.config/fish/private.fish

# nvm
bass source ~/.nvm/nvm.sh

# golang
set -x GOPATH ~/go
set -x $PATH PATH $GOPATH/bin
