#!/usr/bin/env fish
# common config between platforms

# global variables
set -x EDITOR vim
set fish_greeting ""

# aliases
eval (python -m virtualfish compat_aliases)
eval (thefuck --alias | tr '\n' ';')

if type hub > /dev/null
	eval (hub alias -s)
else
    echo "WARNING: hub not installed"
end

# my aliases
alias grip "grep -i"
alias psg "ps -ef | grep"
alias pubip "curl http://canihazip.com/s/; echo ''"
alias cll "clear; ll"

# git abbreviations
abbr -a gg "git status"
abbr -a ga "git add"
abbr -a gau "git add -u"
abbr -a gc "git commit"
abbr -a gco "git checkout"
abbr -a gd "git diff"
abbr -a g "git status -sb"
abbr -a gb "git branch"
abbr -a gl "git log"
abbr -a gll "git log --graph --oneline --all --decorate -n 25"
abbr -a glll "git log --graph --oneline --all --decorate"
abbr -a gtagtime "git log --tags --simplify-by-decoration --pretty='format:%ai %d'"
# get current branch
abbr -a gcb "git rev-parse --abbrev-ref HEAD"

# git prompt config
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_char_dirtystate "+"
set -g __fish_git_prompt_char_untrackedfiles "."
set -g __fish_git_prompt_color_branch magenta
set -g __fish_git_prompt_color_dirtystate blue
set -g __fish_git_prompt_color_stagedstate yellow
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
set -g __fish_git_prompt_color_cleanstate green
