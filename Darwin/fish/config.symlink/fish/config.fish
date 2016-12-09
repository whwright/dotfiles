#!/usr/bin/env fish
# fish config for OSX

# setup local python PATH before calling common config
set -x PATH ~/Library/Python/2.7/bin $PATH
set -x PATH ~/go/bin $PATH

. ~/.config/fish/common.fish
. ~/.config/fish/bl.fish
. ~/.config/fish/private.fish

# nvm
if type bass > /dev/null
    if test -e ~/.nvm/nvm.sh
        bass source ~/.nvm/nvm.sh
    else
        echo "WARNING: nvm not installed"
    end

    if test -e ~/.gvm/scripts/gvm
        bass source ~/.gvm/scripts/gvm
    else
        echo "WARNING: gvm not installed"
    end
else
    echo "WARNING: bass not installed"
end

# golang
set -x GOPATH ~/go
set -x $PATH PATH $GOPATH/bin
