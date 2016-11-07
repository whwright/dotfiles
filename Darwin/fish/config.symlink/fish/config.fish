set -x PATH $PATH ~/Library/Python/2.7/bin
set -x GOPATH ~/go
set -x PATH $PATH $GOPATH/bin

bass source ~/.nvm/nvm.sh

. ~/.config/fish/common.fish
. ~/.config/fish/bl.fish
. ~/.config/fish/private.fish
