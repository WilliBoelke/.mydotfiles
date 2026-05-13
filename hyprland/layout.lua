hl.config({
    dwindle = {
        -- pseudotile removed in 0.55, was doing nothing anyway
        preserve_split = false,
    },
    master = {
        -- new_status = "master",
    },
    binds = {
        workspace_back_and_forth = false,
        allow_workspace_cycles = true,
        pass_mouse_when_bound = false,
    },
})


hl.config({
    general = {
        layout = "master", -- or "master"
    },
})


hl.config({
    scrolling = {
        direction = "down",  -- vertical scrolling for portrait monitor
    },
})