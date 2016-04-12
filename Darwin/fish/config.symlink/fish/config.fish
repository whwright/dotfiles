. ~/.config/fish/aliases.fish

set fisher_home ~/.local/share/fisherman
set fisher_config ~/.config/fisherman
source $fisher_home/config.fish

set -x EDITOR vim
set -x PATH /usr/local/bin $PATH
set -x GOPATH ~/go

bass source ~/.nvm/nvm.sh
eval (python -m virtualfish)

# GIT PROMPT CONFIG
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_char_dirtystate "+"
set -g __fish_git_prompt_char_untrackedfiles "."
set -g __fish_git_prompt_color_branch magenta
set -g __fish_git_prompt_color_dirtystate blue
set -g __fish_git_prompt_color_stagedstate yellow
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
set -g __fish_git_prompt_color_cleanstate green