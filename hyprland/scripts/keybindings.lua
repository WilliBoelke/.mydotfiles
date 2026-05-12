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

-- Menus
hl.bind(mainMod .. " + A", hl.dsp.global("quickshell:toggleSideLeftMenu"))
hl.bind(mainMod .. " + D", hl.dsp.global("quickshell:toggleSideRightMenu"))
hl.bind(mainMod .. " + S", hl.dsp.global("quickshell:toggleFunke"))

-- Display zoom
hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.exec_cmd([[hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') + 0.5}")]]))
hl.bind(mainMod .. " + SHIFT + mouse_up",   hl.dsp.exec_cmd([[hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') - 0.5}")]]))
hl.bind(mainMod .. " + SHIFT + Z",          hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor 1"))

-- Windows
hl.bind(mainMod .. " + Q",           hl.dsp.window.kill())
hl.bind(mainMod .. " + SHIFT + Q",   hl.dsp.exec_cmd("hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill"))
hl.bind(mainMod .. " + F",           hl.dsp.window.fullscreen({ mode = 0 }))
hl.bind(mainMod .. " + M",           hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mainMod .. " + T",           hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + T",   hl.dsp.workspace.opt({ opt = "allfloat", action = "toggle" }))
hl.bind(mainMod .. " + J",           hl.dsp.layout.toggle_split())
hl.bind(mainMod .. " + left",        hl.dsp.focus.move({ dir = "l" }))
hl.bind(mainMod .. " + right",       hl.dsp.focus.move({ dir = "r" }))
hl.bind(mainMod .. " + up",          hl.dsp.focus.move({ dir = "u" }))
hl.bind(mainMod .. " + down",        hl.dsp.focus.move({ dir = "d" }))
hl.bindm(mainMod .. " + mouse:272",  hl.dsp.window.move())
hl.bindm(mainMod .. " + mouse:273",  hl.dsp.window.resize())
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize_active({ x =  100, y = 0 }))
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.resize_active({ x = -100, y = 0 }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.resize_active({ x = 0, y =  100 }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.resize_active({ x = 0, y = -100 }))
hl.bind(mainMod .. " + G",           hl.dsp.window.toggle_group())
hl.bind(mainMod .. " + K",           hl.dsp.layout.swap_split())
hl.bind(mainMod .. " + ALT + left",  hl.dsp.window.swap({ dir = "l" }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.swap({ dir = "r" }))
hl.bind(mainMod .. " + ALT + up",    hl.dsp.window.swap({ dir = "u" }))
hl.bind(mainMod .. " + ALT + down",  hl.dsp.window.swap({ dir = "d" }))
hl.binde("ALT + Tab", hl.dsp.focus.cycle_next())
hl.binde("ALT + Tab", hl.dsp.window.bring_active_to_top())

-- Actions
hl.bind(mainMod .. " + CTRL + R",   hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + SHIFT + A",  hl.dsp.exec_cmd(HYPRSCRIPTS .. "/toggle-animations.sh"))
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

-- Workspaces: switch
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.workspace.go({ id = i }))
end
hl.bind(mainMod .. " + 0", hl.dsp.workspace.go({ id = 10 }))

-- Workspaces: move window
for i = 1, 9 do
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move_to_workspace({ id = i }))
end
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move_to_workspace({ id = 10 }))

-- Workspaces: move all windows via script
for i = 1, 9 do
    hl.bind(mainMod .. " + CTRL + " .. i, hl.dsp.exec_cmd(HYPRSCRIPTS .. "/moveTo.sh " .. i))
end
hl.bind(mainMod .. " + CTRL + 0", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/moveTo.sh 10"))

-- Workspaces: navigation
hl.bind(mainMod .. " + Tab",         hl.dsp.workspace.go({ relative = 1 }))
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.workspace.go({ relative = -1 }))
hl.bind(mainMod .. " + mouse_down",  hl.dsp.workspace.go({ relative = 1 }))
hl.bind(mainMod .. " + mouse_up",    hl.dsp.workspace.go({ relative = -1 }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.workspace.go({ empty = true }))

-- Fn keys
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -q s +10%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -q s 10%-"))
hl.bindle("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bindle("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"))
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause",        hl.dsp.exec_cmd("playerctl pause"))
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"))
hl.bind("XF86Calculator",        hl.dsp.exec_cmd("gnome-calculator"))
hl.bind("XF86Lock",              hl.dsp.exec_cmd("hyprlock"))

hl.bind("code:238", hl.dsp.exec_cmd("brightnessctl -d smc::kbd_backlight s +10"))
hl.bind("code:237", hl.dsp.exec_cmd("brightnessctl -d smc::kbd_backlight s 10-"))