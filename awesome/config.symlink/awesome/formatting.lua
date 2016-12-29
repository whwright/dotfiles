-- TODO: formatting is a meh name

local formatting = {}
formatting.red = "#FF4C4C"
formatting.green = "#78AB46"
formatting.light_blue = "#ADD8E6"

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

return formatting
