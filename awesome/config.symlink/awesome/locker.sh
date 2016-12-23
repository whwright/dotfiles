#!/bin/bash

exec xautolock \
    -detectsleep \
    -time 20 \
    -locker "gnome-screensaver-command --lock" \
    -notify 60 \
    -notifier "notify-send -t 5000 --icon=info 'Screen Lock' 'Screen will lock in 1 minute'"
