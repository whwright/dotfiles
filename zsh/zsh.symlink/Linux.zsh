#!/usr/bin/env zsh

#############
# FUNCTIONS #
#############

# awesome notification
# https://www.reddit.com/r/awesomewm/comments/1gyt8x/notifications_for_completed_commands/
function aalert {
    local return_value=$?                  # get return value of the last command
    local end_time=$(date)                 # get time of completion
    local last_cmd=${history[${HISTCMD}]}  # get current command
    last_cmd=${last_cmd%[;&|]*}            # remove "; alert" from it

    # set window title so we can get back to it
    echo -ne "\e]2;$last_cmd\a"

    last_cmd=${last_cmd//\"/'\"'}        # replace " for \" to not break lua format

    # check if the command was successful
    local bg_color
    local fg_color
    if [[ ${return_value} == 0 ]]; then
        return_value="SUCCESS"
        bg_color="beautiful.bg_normal"
        fg_color="beautiful.fg_normal"
    else
        return_value="FAILURE"
        bg_color="beautiful.bg_urgent"
        fg_color="beautiful.fg_urgent"
    fi

    # compose the notification
    local message="naughty.notify({ \
                title   = \"Command completed on: \t\t${end_time}\", \
                text    = \"↪ ${last_cmd}\" .. newline .. \"${return_value}\", \
                timeout = 0, \
                bg      = ${bg_color},
                fg      = ${fg_color},
            })"
    # send it to awesome
    echo ${message} | awesome-client
}

############
# KEYBINDS #
############

# keybind for KP_ENTER (https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=685511)
if (( ${+terminfo[kent]} )); then
    kent="${terminfo[kent]}"
else
    kent=$(TERM=xterm echoti kent 2>/dev/null)
    # If there is nothing in `$kent' yet, use "ESC O M", which is
    # what xterm and urxvt use.
    [[ -z "$kent" ]] && kent=$'\eOM'
fi
bindkey "$kent" accept-line
unset kent

bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word
