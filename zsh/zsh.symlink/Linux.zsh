#!/usr/bin/env zsh
# Linux config

export PATH=${PATH}:~/.local/bin
export PATH=${PATH}:/usr/local/go/bin

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

alias mylsblk="lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL"
# OSX compatible copy/paste
alias pbcopy="xclip -selection c"
alias pbpaste="xclip -selection clipboard -o"

# awesome notification
# https://www.reddit.com/r/awesomewm/comments/1gyt8x/notifications_for_completed_commands/
function alert {
    RVAL=$?                         # get return value of the last command
    DATE=$(date)                    # get time of completion
    LAST=${history[${HISTCMD}]}     # get current command
    LAST=${LAST%[;&|]*}             # remove "; alert" from it

    # set window title so we can get back to it
    echo -ne "\e]2;$LAST\a"

    LAST=${LAST//\"/'\"'}        # replace " for \" to not break lua format

    # check if the command was successful
    if [[ ${RVAL} == 0 ]]; then
        RVAL="SUCCESS"
        BG_COLOR="beautiful.bg_normal"
        FG_COLOR="beautiful.fg_normal"
    else
        RVAL="FAILURE"
        BG_COLOR="beautiful.bg_urgent"
        FG_COLOR="beautiful.fg_urgent"
    fi

    # compose the notification
    MESSAGE="naughty.notify({ \
                title   = \"Command completed on: \t\t${DATE}\", \
                text    = \"↪ ${LAST}\" .. newline .. \"${RVAL}\", \
                timeout = 0, \
                bg      = ${BG_COLOR},
                fg      = ${FG_COLOR},
                width   = 430,
            })"
    # send it to awesome
    echo ${MESSAGE} | awesome-client

}
