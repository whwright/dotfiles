# ZSH Theme - Preview: http://gyazo.com/8becc8a7ed5ab54a0262a470555c3eed.png
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"


if [[ $UID -eq 0 ]]; then
    local user_host='%{$terminfo[bold]$fg[red]%}%n@%m%{$reset_color%}'
    local user_symbol='#'
else
    local user_host='%{$terminfo[bold]$fg[green]%}%n@%m%{$reset_color%}'
    local user_symbol='$'
fi

local current_dir='%{$terminfo[bold]$fg[blue]%} %~%{$reset_color%}'
local rvm_ruby=''
if which rvm-prompt &> /dev/null; then
  rvm_ruby='%{$fg[red]%}‹$(rvm-prompt i v g)›%{$reset_color%}'
else
  if which rbenv &> /dev/null; then
    rvm_ruby='%{$fg[red]%}‹$(rbenv version | sed -e "s/ (set.*$//")›%{$reset_color%}'
  fi
fi
local git_branch='$(git_prompt_info)%{$reset_color%}'

PROMPT="${user_host} ${current_dir} ${rvm_ruby} ${git_branch}
%B↪%b "
RPS1="%B${return_code}%b"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}<"
ZSH_THEME_GIT_PROMPT_SUFFIX="> %{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_DIRTY="${VCS_DIRTY_COLOR} ✘${VCS_SUFIX_COLOR}"
# ZSH_THEME_GIT_PROMPT_CLEAN="${VCS_CLEAN_COLOR} ✔${VCS_SUFIX_COLOR}"
# ZSH_THEME_GIT_PROMPT_ADDED="${PR_RESET}${PR_YELLOW} ✚${PR_RESET}"
# ZSH_THEME_GIT_PROMPT_MODIFIED="${PR_RESET}${PR_YELLOW} ✹${PR_RESET}"
# ZSH_THEME_GIT_PROMPT_DELETED="${PR_RESET}${PR_YELLOW} ✖${PR_RESET}"
# ZSH_THEME_GIT_PROMPT_RENAMED="${PR_RESET}${PR_YELLOW} ➜${PR_RESET}"
# ZSH_THEME_GIT_PROMPT_UNMERGED="${PR_RESET}${PR_YELLOW} ═${PR_RESET}"
# ZSH_THEME_GIT_PROMPT_UNTRACKED="${PR_RESET}${PR_YELLOW} ✭${PR_RESET}"
