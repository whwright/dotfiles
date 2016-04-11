function fish_prompt
    set -l last_status $status

    set_color yellow
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

    set color normal
    if not test $last_status -eq 0
        set_color $fish_color_error
    end

    # Line 2
    echo
    printf '↪ '
    set_color normal
end