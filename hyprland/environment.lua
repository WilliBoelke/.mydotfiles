-- =============================================================================
-- Environment Variables
-- =============================================================================

hl.env("WLR_DRM_NO_ATOMIC", "0")
hl.env("__GL_GSYNC_ALLOWED", "1")

-- XDG
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Qt
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- GTK
hl.env("GDK_SCALE", "1")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("CLUTTER_BACKEND", "wayland")

-- Firefox
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- Cursor
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Adwaita")

-- Electron/Chromium
hl.env("OZONE_PLATFORM", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

-- SDL
hl.env("SDL_VIDEODRIVER", "wayland")

-- XWayland
hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})