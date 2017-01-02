local awful = require("awful")

do
    local cmds =
    {
        "autorandr --change",
        "dropbox start --install",
        "nm-applet"
    }

    for _,i in pairs(cmds) do
        awful.util.spawn(i)
    end

    local shell_cmds =
    {
        "gnome-screensaver",
        "gnome-settings-daemon",
        "~/.config/awesome/locker.sh"
    }

    for _,i in pairs(shell_cmds) do
        awful.util.spawn_with_shell(i)
    end
end
