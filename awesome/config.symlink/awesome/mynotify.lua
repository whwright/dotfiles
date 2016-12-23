-- TODO: write reusable notifictions to use over naughty
local awful = require("awful")

local mynotify = {}

function mynotify.notify(args)
    awful.util.spawn_with_shell('notify-send hello')
end

return mynotify
