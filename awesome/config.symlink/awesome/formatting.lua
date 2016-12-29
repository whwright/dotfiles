
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
