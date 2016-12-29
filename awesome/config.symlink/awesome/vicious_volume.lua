
local wibox = require("wibox")
local vicious = require("vicious")

volume_widget = wibox.widget.textbox()
vicious.register(volume_widget, vicious.widgets.volume,
    function(widget, args)
        local label = { ["♫"] = "O", ["♩"] = "M" }
        return "Volume: " .. args[1] .. "% State: " .. label[args[2]]
    end, 2, "PCM")
