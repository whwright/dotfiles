-- Import the wezterm module
local wezterm = require 'wezterm'

wezterm.log_info("hello world! my name is " .. wezterm.hostname())

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


-- Removes the title bar, leaving only the tab bar
config.window_decorations = 'RESIZE'


-- config.send_composed_key_when_left_alt_is_pressed = true
-- config.use_ime = false
-- config.allow_win32_input_mode = false
config.disable_default_key_bindings = true

config.keys = {
    -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
    {key="LeftArrow", mods="OPT", action=wezterm.action{SendString="\x1bb"}},
    -- Make Option-Right equivalent to Alt-f; forward-word
    {key="RightArrow", mods="OPT", action=wezterm.action{SendString="\x1bf"}},
}


-- Returns our config to be evaluated. We must always do this at the bottom of this file
return config



-- -- config.allow_win32_input_mode = false
-- -- config.send_composed_key_when_left_alt_is_pressed = false
-- -- config.use_ime = false

-- config.keys = {
--     -- { key="LeftOption", action=act.SendString("+Esc") }
-- }

-- -- If you have your own leader key, make sure to set it before loading this
-- -- plugin.
-- config.leader = { key = "\\", mods = "CTRL" }

-- -- Add these lines:
-- require("wez-tmux.plugin").apply_to_config(config, {})

-- -- and finally, return the configuration to wezterm
-- return config
