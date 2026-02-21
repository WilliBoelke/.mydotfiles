#!/bin/bash

# this opens a flaoting window at the current cursor coordinates and clamps it to the curretnly focused monitor.
# it uses the open_floating_window_at.sh script, which is more generic and can be used to open any app at the cursor position.
# usage is open_floating_window_at_cursor.sh <command>

# get the cursor coordinates
cursor=$(hyprctl cursorpos)
cursor_x=$(echo "$cursor" | cut -d',' -f1 | tr -d ' ')
cursor_y=$(echo "$cursor" | cut -d',' -f2 | tr -d ' ')

# those are global, lets move them into the currently focused monitor space.
# get the currently focused monitor
monitor_info=$(hyprctl monitors -j | jq '.[] | select(.focused == true)')
mon_x=$(echo "$monitor_info" | jq '.x | floor')
mon_y=$(echo "$monitor_info" | jq '.y | floor')

# convert global cursor coordinates to monitor-local
local_x=$((cursor_x - mon_x))
local_y=$((cursor_y - mon_y))

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/open_floating_window_at.sh" "$local_x" "$local_y" "$@"