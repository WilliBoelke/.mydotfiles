require("colors")

hl.config({
    decoration = {
        rounding = 12,
        active_opacity = 0.9,
        inactive_opacity = 0.8,
        fullscreen_opacity = 1,
        blur = {
            enabled = true,
            size = 15,
            passes = 6,
            new_optimizations = true,
            ignore_opacity = true,
        },
        shadow = {
            enabled = true,
            range = 30,
            render_power = 3,
            color = shadow,
        },
    },
})

hl.layer_rule({
    name = "blur_quickshell",
    match = { namespace = "quickshell" },
    blur = true,
    ignore_alpha = 0.1,
    xray = true,
})

hl.layer_rule({
    name = "blur_funke",
    match = { namespace = "funke" },
    blur = true,
    ignore_alpha = 0,
    no_anim = true,
    xray = true,
})