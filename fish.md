
Putting some old fish configs here I have not replicated 100%

##### fish git prompt
My configs
```
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
```

Default values:
https://github.com/fish-shell/fish-shell/blob/master/share/functions/__fish_git_prompt.fish#L632
Notes:
https://github.com/fish-shell/fish-shell/blob/master/share/functions/__fish_git_prompt.fish#L123
