-- Import the wezterm module
local wezterm = require("wezterm")
local default_keys = require("default_keys")

wezterm.log_info("hello world! my name is " .. wezterm.hostname())

local is_darwin <const> = wezterm.target_triple:find("darwin") ~= nil
local is_linux <const> = wezterm.target_triple:find("linux") ~= nil

-- Creates a config object which we will be adding our config to
local config = wezterm.config_builder()

-- (This is where our config will go)
-- config.color_scheme = "Tokyo Night"
-- config.color_scheme = "Pnevma"
config.color_scheme = "Idle Toes (Gogh)"
-- config.color_scheme = "Darktooth (base16)"

-- disable ligatures
config.font = wezterm.font({
	family = "JetBrains Mono",
	weight = "Medium",
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
})
config.font_size = 13

-- Removes the title bar, leaving only the tab bar
if is_darwin then
	config.window_decorations = "RESIZE"
end
config.hide_tab_bar_if_only_one_tab = true

-- Disable default keys, and then bring them back in via default_keys.lua
config.disable_default_key_bindings = true
keys = {
	-- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
	{ key = "LeftArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bb" }) },
	-- Make Option-Right equivalent to Alt-f; forward-word
	{ key = "RightArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bf" }) },
}
for k, v in pairs(default_keys) do
	keys[k] = v
end
config.keys = keys

return config
