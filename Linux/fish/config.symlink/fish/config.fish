eval (dircolors -c $HOME/.dircolors/256dark)

. ~/.config/fish/aliases.fish
. ~/.config/fish/vandelay.fish

alias tcli "truecrypt-cli"
alias dlc "deluge-console"

set -x EDITOR vim
set -x PATH $DEV/gradle-2.2.1/bin $PATH
set -x PATH /usr/local/go/bin $PATH
set -x GOPATH ~/Development/go
set -x JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

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
