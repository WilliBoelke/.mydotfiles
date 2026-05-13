hl.window_rule({
    match = { class = ".*org.pulseaudio.pavucontrol.*" },
    float = true,
    center = true,
    size = { 700, 600 },
})

-- bluetooth manager
hl.window_rule({
    match = { class = "blueman-manager" },
    float = true,
    center = true,
    size = { 700, 600 },
})


-- nwg-displays (monitor configuration)
hl.window_rule({
    match = { class = "nwg-displays" },
    float = true,
    center = true,
    size = { 700, 600 },
})


hl.window_rule({
    match = { class = "nwg-look" },
    float = true,
    center = true,
    size = { 700, 600 },
})

-- Picture-in-Picture (browser feature)
hl.window_rule({
    match = { class = "nwg-displays" },
    float = true,
    center = true,
    size = { 700, 600 },
})

-- JetBrains IDE floating popup focus fix
hl.window_rule({
    match = { class = "^(jetbrains-.*)$" },
    float = true,
    center = true,
    focus_on_activate = true,
})

-- JetBrains IDE tooltip/menu nofocus fix
hl.window_rule({
    match = {
        class = "^(jetbrains-.*)$",
         title="^win\\d+$"
    },
    no_focus = true,
    opaque = true
})

-- Steam games{
hl.window_rule({
    match = { class = "^steam_app\\d+$" },
    fullscreen = true,
    monitor = 0,
    workspace = 3,
})