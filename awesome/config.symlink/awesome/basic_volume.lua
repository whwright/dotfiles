local wibox = require("wibox")
local awful = require("awful")

volume_widget = wibox.widget.textbox()
volume_widget:set_align("right")

function fg(text, args)
  local span = "<span"

  if args and args.color ~= nil then
    span = span .. " color=\"" .. args.color .. "\""
  end

  if args and args.strikethrough == true then
    span = span .. " strikethrough=\"true\""
  end

  span = span .. ">" .. text .. "</span>"

  return span
end

function update_volume(widget)
  local fd = io.popen("amixer sget Master")
  local status = fd:read("*all")
  fd:close()

  local vol_percent = string.match(status, "(%d?%d?%d)%%")

  status = string.match(status, "%[(o[^%]]*)%]")
  local muted
  if string.find(status, "on", 1, true) then
    muted = false
  else
    muted = true
  end

  args = {}
  if muted then
    args.strikethrough = true
  end

  span = fg(vol_percent .. "%", args)
  label = "Volume: " .. span
  widget:set_markup(label)
end

update_volume(volume_widget)

mytimer = timer({ timeout = 0.2 })
mytimer:connect_signal("timeout", function () update_volume(volume_widget) end)
mytimer:start()
