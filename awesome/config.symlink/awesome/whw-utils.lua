
local whw = {}

-- utility functions

whw.capture = function(cmd, raw)
    local f = assert(io.popen(cmd, "r"))
    local s = assert(f:read("*a"))
    f:close()
    if raw then return s end
    s = string.gsub(s, "^%s+", "")
    s = string.gsub(s, "%s+$", "")
    s = string.gsub(s, "[\n\r]+", " ")
    return s
end

whw.get_hostname = function()
    return whw.capture("hostname")
end

whw.has_battery = function()
    power_supply = whw.capture("ls /sys/class/power_supply/")
    if power_supply == "" then
        return false
    end
    return true
end

-- formatting

whw.colors = {
    red = "#FF4C4C",
    green = "#78AB46",
    light_blue = "#ADD8E6"
}

whw.fg = function(text, args)
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

return whw
