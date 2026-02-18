#!/usr/bin/env bash
# Launch nwg-dock-hyprland

killall nwg-dock-hyprland 2>/dev/null
sleep 0.2

# Launch dock with relative path to config dir
cd ~/.config/nwg-dock-hyprland
nwg-dock-hyprland -i 32 -w 5 -mb 10 -x \
  -s themes/modern/style.css \
  -c ~/.config/hypr/scripts/launcher.sh
