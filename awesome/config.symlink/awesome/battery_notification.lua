
local awful = require("awful")
local naughty = require("naughty")

local function trim(s)
  return s:find'^%s*$' and '' or s:match'^%s*(.*%S)'
end

local function bat_notification()

  local f_capacity = assert(io.open("/sys/class/power_supply/BAT0/capacity", "r"))
  local f_status = assert(io.open("/sys/class/power_supply/BAT0/status", "r"))

  local bat_capacity = tonumber(f_capacity:read("*all"))
  local bat_status = trim(f_status:read("*all"))

  if (bat_capacity <= 10 and bat_status == "Discharging") then

    local subject = "Battery Warning"
    local message = "Battery low! " .. bat_capacity .. "%" .. " left!"
    -- awful.util.spawn_with_shell("notify-send -t 5000 --icon=battery-low '" .. subject .. "' '" .. message .. "'")
    naughty.notify({
        title      = "Battery Warning",
        text       = "Battery low! " .. bat_capacity .."%" .. " left!",
        icon       = "/usr/share/icons/gnome/256x256/status/battery-caution.png",
        icon_size  = 85,
        fg         = "#ff0000",
        font       = "sans 12",
        height     = 100,
        width      = 350,
        timeout    = 10
    })
  end
end

battimer = timer({timeout = 120})
battimer:connect_signal("timeout", bat_notification)
battimer:start()
