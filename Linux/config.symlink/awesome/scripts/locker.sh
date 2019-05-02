#!/bin/bash


exec light-locker --lock-on-suspend &

exec xautolock -detectsleep \
  -time 5 -locker "light-locker-command -l" \
  -notify 30 \
  -notifier "notify-send -u critical -t 10000 -- 'LOCKING screen in 30 seconds'"
  -noclose &
