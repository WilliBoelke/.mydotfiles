## Theming
### Ember Theme
The Ember theme uses a warm orange accent (`#E9643A`) with a dark glassmorphism aesthetic.

#### GTK Theme
The Ember GTK theme is based on the Ant theme and lives in `~/.local/share/themes/Ember/`. It is NOT tracked in this repo.

```bash
# Clone Ant theme as Ember base
git clone --depth=1 https://github.com/EliverLara/Ant.git ~/.local/share/themes/Ember
sed -i 's/Name=Ant/Name=Ember/' ~/.local/share/themes/Ember/index.theme

# Symlink dotfiles gtk-3.20 into theme (replaces upstream version)
ln -s ~/dotfiles/config/gtk-3.20 ~/.local/share/themes/Ember/gtk-3.20
```

#### GTK3.20 Theme (Ember)
The gtk-3.20 theme is fully owned by dotfiles and uses SCSS as its source.
After any color changes to `_colors.scss`, recompile:

```bash
# Install sassc if not present
sudo pacman -S sassc

# Recompile
cd ~/dotfiles/config/gtk-3.20
rm -f gtk-dark.css gtk.css
sassc -t expanded gtk-dark.scss gtk-dark.css
sassc -t expanded gtk.scss gtk.css
```

All color changes should be made in `_colors.scss` only — never edit `gtk-dark.css` directly as it is a generated file.

#### GTK4 Theming
GTK4/libadwaita apps respect dark mode and accent color via gsettings:

```bash
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface accent-color 'orange'
gsettings set org.gnome.desktop.interface gtk-theme 'Ember'
gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
```

These are also set on login via Hyprland autostart.

#### Qt6 Theming (qt6ct)
Qt6 apps are themed via `qt6ct`. The Ember color palette lives in `~/.local/share/qt6ct/colors/Ember.conf` (symlinked from dotfiles).

```bash
mkdir -p ~/.local/share/qt6ct/colors
ln -s ~/dotfiles/config/qt6ct/colors/Ember.conf ~/.local/share/qt6ct/colors/Ember.conf
```

#### KDE/KFrameworks Theming (Dolphin etc.)
KFrameworks apps like Dolphin have an additional color layer on top of Qt that ignores qt6ct. Two config files handle this:
- `~/.config/kdeglobals` — sets Ember colors for KFrameworks color roles
- `~/.config/kdedefaults/kdeglobals` — sets the default widget style and color scheme

#### Dolphin Fix
Dolphin has a bug where it fails to load the color scheme correctly on launch outside a full Plasma session. Fix is applied via `dolphinrc`:

```ini
[UiSettings]
ColorScheme=default
```

See: https://bbs.archlinux.org/viewtopic.php?id=311198

#### XDG Desktop Portal
`xdg-desktop-portal-gtk` must be installed for qt6ct and libadwaita dark mode to work correctly:

```bash
sudo pacman -S xdg-desktop-portal-gtk
```

## Installation
### Dependencies
```bash
sudo pacman -S hyprland hyprpaper hypridle hyprlock hyprpicker \
    qt6ct qt6-svg qt6-multimedia \
    xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
    sassc \
    kitty grim slurp wl-clipboard cliphist \
    nwg-displays oh-my-posh quickshell \
    dolphin kasts alligator kdeconnect partitionmanager
yay -S anyrun-git
```

### Symlinks
```bash
# Hyprland
mv ~/.config/hypr ~/.config/hypr.backup
ln -s ~/dotfiles/hyprland ~/.config/hypr

# Quickshell
ln -s ~/dotfiles/quickshell ~/.config/quickshell

# Anyrun
ln -s ~/dotfiles/anyrun ~/.config/anyrun

# GTK & Qt theming
ln -s ~/dotfiles/config/gtk-3.0 ~/.config/gtk-3.0
ln -s ~/dotfiles/config/gtk-4.0 ~/.config/gtk-4.0
ln -s ~/dotfiles/config/qt6ct ~/.config/qt6ct

# GTK theme (gtk-3.20 replaces upstream)
ln -s ~/dotfiles/config/gtk-3.20 ~/.local/share/themes/Ember/gtk-3.20

# KFrameworks theming
ln -s ~/dotfiles/config/kdeglobals ~/.config/kdeglobals
mkdir -p ~/.config/kdedefaults
ln -s ~/dotfiles/config/kdedefaults/kdeglobals ~/.config/kdedefaults/kdeglobals

# Dolphin
ln -s ~/dotfiles/config/dolphinrc ~/.config/dolphinrc

# qt6ct color palette
mkdir -p ~/.local/share/qt6ct/colors
ln -s ~/dotfiles/config/qt6ct/colors/Ember.conf ~/.local/share/qt6ct/colors/Ember.conf

# Shell
ln -s ~/dotfiles/shell/.bashrc ~/.bashrc
ln -s ~/dotfiles/shell/.zshrc ~/.zshrc
ln -s ~/dotfiles/shell/bashrc ~/.config/bashrc
ln -s ~/dotfiles/shell/zshrc ~/.config/zshrc
ln -s ~/dotfiles/shell/ohmyposh ~/.config/ohmyposh

#btop
ln -s ~/dotfiles/btop/ ~/.config/btop
```

### Post-Install: Apply gsettings
```bash
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface accent-color 'orange'
gsettings set org.gnome.desktop.interface gtk-theme 'Ember'
gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
```

### Environment Variables
The configuration sets the following critical environment variables:
- `HYPRSCRIPTS`: Points to `~/.config/hypr/scripts`
- `QT_QPA_PLATFORMTHEME=qt6ct`: Qt theming via qt6ct
- Wayland/Qt/GTK variables for proper application rendering
- See `hyprland/environment.conf` for complete list

## Notes
### ml4w Migration
This configuration was originally extracted from the ml4w-dotfiles installer. Some scripts under `hyprland/scripts/` still reference `~/.config/ml4w/` paths — these are being cleaned up incrementally. Thank you ml4w for getting me started!

### Monitor Configuration
The monitor setup in `monitors.conf` was generated by `nwg-displays` and can be modified manually or regenerated with the tool.