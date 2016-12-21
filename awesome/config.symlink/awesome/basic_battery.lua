local wibox = require("wibox")

battery_widget = wibox.widget.textbox()
battery_widget:set_text("Bat: ?")
batterywidgettimer = timer({ timeout = 5 })
batterywidgettimer:connect_signal("timeout",
    function()
        fh = assert(io.popen("acpi | cut -d, -f 2"))
        battery_widget:set_text("Bat:" .. fh:read("*l") .. "")
        fh:close()
    end
)
batterywidgettimer:start()

