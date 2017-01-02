local awful = require("awful")

do
    local cmds =
    {
        "/usr/local/bin/autorandr --change",
        "/usr/bin/dropbox start --install"
    }

    for _,i in pairs(cmds) do
        awful.util.spawn(i)
    end

    local shell_cmds =
    {
        "/usr/bin/gnome-screensaver",
        "/usr/bin/gnome-settings-daemon",
        "~/.config/awesome/locker.sh"
    }

    for _,i in pairs(shell_cmds) do
        awful.util.spawn_with_shell(i)
    end
end
