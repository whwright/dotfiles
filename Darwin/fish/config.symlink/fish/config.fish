. ~/.config/fish/common.fish
. ~/.config/fish/bl.fish

# TODO: do I need this?
set fisher_home ~/.local/share/fisherman
set fisher_config ~/.config/fisherman
source $fisher_home/config.fish

set -x GOPATH ~/go
set -x PATH $GOPATH/bin $PATH

bass source ~/.nvm/nvm.sh
