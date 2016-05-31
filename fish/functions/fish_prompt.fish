function fish_prompt
    set -l last_status $status

    if test $VIRTUAL_ENV
        # if fish_prompt is not already overridden
        type '_old_fish_prompt' > /dev/null 2>&1
        if test $status -ne 0
            set_color normal
            printf '('
            set_color -o white
            printf '%s' (basename "$VIRTUAL_ENV")
            set_color normal
            printf ') '
        end
    end

    fish_prompt_short

    set color normal
    if not test $last_status -eq 0
        set_color $fish_color_error
    end

    # Line 2
    echo
    printf '↪ '
    set_color normal
end

function fish_prompt_short
    set_color normal
    printf "%s" (whoami)
    printf "@"
    printf "%s " (hostname|cut -d . -f 1)

    set_color $fish_color_cwd
    printf '%s' (prompt_pwd)

    set_color normal
    printf ' %s ' (__fish_git_prompt)
end

function fish_prompt_long
    set_color yellow
    printf '[%s] ' (date +%X)
    printf '%s' (whoami)

    set_color normal
    printf ' at '

    set_color red
    printf '%s' (hostname|cut -d . -f 1)

    set_color normal
    printf ' in '

    set_color $fish_color_cwd
    printf '%s' (pwd)

    set_color normal
    printf ' %s ' (__fish_git_prompt)
end
