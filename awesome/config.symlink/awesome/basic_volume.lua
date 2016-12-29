local wibox = require("wibox")
local awful = require("awful")

volume_widget = wibox.widget.textbox()
volume_widget:set_align("right")

function update_volume(widget)
   local fd = io.popen("amixer sget Master")
   local status = fd:read("*all")
   fd:close()

   -- local volume = tonumber(string.match(status, "(%d?%d?%d)%%")) / 100
   local percent = string.match(status, "(%d?%d?%d)%%")
   percent = string.format("%3d", percent)
   -- remove spaces
   percent = percent:gsub("%s+", "")

   local label = percent

   status = string.match(status, "%[(o[^%]]*)%]")
   if string.find(status, "on", 1, true) then
       -- For the volume numbers
       label = label .. "%"
   else
       -- For the mute button
       -- label = label .. "M"
       label = "M"
   end

   label = "Volume: " .. label
   widget:set_markup(label)
end

update_volume(volume_widget)

mytimer = timer({ timeout = 0.2 })
mytimer:connect_signal("timeout", function () update_volume(volume_widget) end)
mytimer:start()
