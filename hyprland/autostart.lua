hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("quickshell")
    hl.exec_cmd("hypridle")
    --watch cliphist store
    hl.exec_cmd("wl-paste")
    --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOPexec-once = gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    hl.exec_cmd("dbus-update-activation-environment")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface accent-color 'orange'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Ember'")
    hl.exec_cmd("hyprctl setcursor Adwaita 24")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
end)


hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
end)