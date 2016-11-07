. ~/.config/fish/common.fish
. ~/.config/fish/bl.fish
. ~/.config/fish/private.fish

set -x GOPATH ~/go
set -x PATH $GOPATH/bin $PATH

bass source ~/.nvm/nvm.sh
