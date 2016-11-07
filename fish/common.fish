. ~/.config/fish/aliases.fish
. ~/.config/fish/abbr.fish

set -x PATH /usr/local/bin $PATH
set -x PATH ~/.local/bin $PATH

set fish_greeting ""

eval (python -m virtualfish compat_aliases)
eval (thefuck --alias | tr '\n' ';')

if type hub > /dev/null
	eval (hub alias -s)
else
    echo "WARNING: hub not installed"
end

set -x EDITOR vim

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
