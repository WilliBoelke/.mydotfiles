require("colors")

hl.config({
    general = {
        gaps_in = 10,
        gaps_out = 20,
        border_size = 2,
        col = {
            active_border = { colors = { "rgba(d55c1bff)" }, angle = 0 },
            inactive_border = { colors = { "rgba(3f484aff)" }, angle = 0 },
        },
        layout = "dwindle",
        resize_on_border = true,
    },
})