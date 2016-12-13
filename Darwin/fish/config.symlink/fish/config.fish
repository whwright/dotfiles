#!/usr/bin/env fish
# fish config for OSX

# setup local python PATH before calling common config
set -x PATH $PATH ~/Library/Python/2.7/bin
set -x PATH $PATH ~/.myscripts
set -x GOPATH ~/go
set -x PATH $PATH ~/go/bin

. ~/.config/fish/common.fish
