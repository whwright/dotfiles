. ~/.config/fish/aliases.fish

set -x EDITOR vim
set -x PATH /usr/local/bin $PATH

set -x GOPATH ~/go

# Path to Oh My Fish install.
set -gx OMF_PATH "/Users/harrison/.local/share/omf"
# Customize Oh My Fish configuration path.
#set -gx OMF_CONFIG "/Users/harrison/.config/omf"
# Load oh-my-fish configuration.
source $OMF_PATH/init.fish

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