hl.on("hyprland.start", function()
    hl.exec_once("hyprpaper")
    hl.exec_once("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_once("quickshell")
    hl.exec_once("hypridle")
    --watch cliphist store
    hl.exec_once("wl-paste")
    --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOPexec-once = gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    hl.exec_once("dbus-update-activation-environment")
    hl.exec_once("gsettings set org.gnome.desktop.interface accent-color 'orange'")
    hl.exec_once("gsettings set org.gnome.desktop.interface gtk-theme 'Ember'")
    hl.exec_once("hyprctl setcursor Adwaita 24")
end)


hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
end)