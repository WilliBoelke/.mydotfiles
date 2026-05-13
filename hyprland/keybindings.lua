-- =============================================================================
-- Key bindings
-- =============================================================================

local mainMod = "SUPER"
local HYPRSCRIPTS = "~/.config/hypr/scripts"

-- Applications
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + B",      hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd("thunar"))
hl.bind("ALT + C",              hl.dsp.exec_cmd(HYPRSCRIPTS .. "/colorpicker.sh"))

-- Menus (Quickshell globals)
hl.bind(mainMod .. " + A", hl.dsp.global("quickshell:toggleSideLeftMenu"))
hl.bind(mainMod .. " + D", hl.dsp.global("quickshell:toggleSideRightMenu"))
hl.bind(mainMod .. " + S", hl.dsp.global("quickshell:toggleFunke"))

-- Display zoom
hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.exec_cmd([[hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') + 0.5}")]]))
hl.bind(mainMod .. " + SHIFT + mouse_up",   hl.dsp.exec_cmd([[hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') - 0.5}")]]))
hl.bind(mainMod .. " + SHIFT + Z",          hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor 1"))

-- Windows
hl.bind(mainMod .. " + Q",           hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q",   hl.dsp.exec_cmd("hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill"))
hl.bind(mainMod .. " + F",           hl.dsp.window.fullscreen({ mode = 0 }))
hl.bind(mainMod .. " + M",           hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mainMod .. " + T",           hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + T",   hl.dsp.exec_cmd("hyprctl dispatch workspaceopt allfloat"))
hl.bind(mainMod .. " + J",           hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + left",        hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right",       hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",          hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",        hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + mouse:272",   hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273",   hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 100 0"),  { repeating = true })
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.exec_cmd("hyprctl dispatch resizeactive -100 0"), { repeating = true })
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 100"),  { repeating = true })
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -100"), { repeating = true })
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("hyprctl dispatch togglegroup"))
hl.bind(mainMod .. " + K",           hl.dsp.layout("swapsplit"))
hl.bind(mainMod .. " + ALT + left",  hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + ALT + up",    hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + ALT + down",  hl.dsp.window.swap({ direction = "down" }))
hl.bind("ALT + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end, { repeating = true })

-- Actions
hl.bind(mainMod .. " + CTRL + R",   hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + SHIFT + A",  hl.dsp.exec_cmd(HYPRSCRIPTS .. "/toggle-animation.lua.sh"))
hl.bind(mainMod .. " + PRINT",      hl.dsp.exec_cmd(HYPRSCRIPTS .. "/screenshot.sh"))
hl.bind(mainMod .. " + ALT + F",    hl.dsp.exec_cmd(HYPRSCRIPTS .. "/screenshot.sh --instant"))
hl.bind(mainMod .. " + SHIFT + S",  hl.dsp.exec_cmd(HYPRSCRIPTS .. "/screenshot.sh --instant-area"))
hl.bind(mainMod .. " + ALT + A",    hl.dsp.exec_cmd(HYPRSCRIPTS .. "/text-extractor.sh"))
hl.bind(mainMod .. " + CTRL + K",   hl.dsp.exec_cmd(HYPRSCRIPTS .. "/keybindings.sh"))
hl.bind(mainMod .. " + SHIFT + R",  hl.dsp.exec_cmd(HYPRSCRIPTS .. "/loadconfig.sh"))
hl.bind(mainMod .. " + ALT + G",    hl.dsp.exec_cmd(HYPRSCRIPTS .. "/gamemode.sh"))
hl.bind(mainMod .. " + CTRL + L",   hl.dsp.exec_cmd(HYPRSCRIPTS .. "/power.sh lock"))
hl.bind(mainMod .. " + SHIFT + H",  hl.dsp.exec_cmd(HYPRSCRIPTS .. "/hyprshade.sh"))
hl.bind("CTRL + Tab",               hl.dsp.exec_cmd(HYPRSCRIPTS .. "/focus.sh"))

-- Workspaces: switch, move window, move all windows
for i = 1, 10 do
    local key = i % 10  -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + " .. key,  hl.dsp.exec_cmd(HYPRSCRIPTS .. "/moveTo.sh " .. i))
end

-- Workspaces: navigation
hl.bind(mainMod .. " + Tab",         hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + mouse_down",  hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",    hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.focus({ workspace = "empty" }))

-- Fn keys
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -q s +10%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -q s 10%-"), { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"),      { locked = true })
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause",        hl.dsp.exec_cmd("playerctl pause"),      { locked = true })
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true })
hl.bind("XF86Calculator",        hl.dsp.exec_cmd("gnome-calculator"))
hl.bind("XF86ScreenSaver", hl.dsp.exec_cmd("hyprlock"))

hl.bind("code:238", hl.dsp.exec_cmd("brightnessctl -d smc::kbd_backlight s +10"))
hl.bind("code:237", hl.dsp.exec_cmd("brightnessctl -d smc::kbd_backlight s 10-"))