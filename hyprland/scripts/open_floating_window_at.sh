#!/bin/bash
# Usage: open_floating_window_at.sh <x> <y> <command>

x=$1
y=$2
shift 2

monitor_info=$(hyprctl monitors -j | jq '.[] | select(.focused == true)')
mon_width=$(echo "$monitor_info" | jq '.width | floor')
mon_height=$(echo "$monitor_info" | jq '.height | floor')
mon_x=$(echo "$monitor_info" | jq '.x | floor')
mon_y=$(echo "$monitor_info" | jq '.y | floor')

# Convert local coordinates to global
x=$((mon_x + x))
y=$((mon_y + y))

app_class=$(basename "$1")

hyprctl dispatch exec "$@"

# Wait for window to appear trying to catch it in an intervall, so we can
# position it asap
# Snapshot existing window addresses before launch
before=$(hyprctl clients -j | jq -r '.[].address')

hyprctl dispatch exec "$@"

# Poll for a new window that wasn't in the snapshot
for i in {1..20}; do
    sleep 0.1
    win_address=$(hyprctl clients -j | jq -r --argjson before "$(echo "$before" | jq -R . | jq -s .)" \
        '[.[] | select(.address as $a | $before | index($a) | not)] | last | .address')
    [ "$win_address" != "null" ] && [ -n "$win_address" ] && break
done

# Get actual window size for clamping
win_w=$(hyprctl clients -j | jq -r '.[] | select(.address == "'"$win_address"'") | .size[0]')
win_h=$(hyprctl clients -j | jq -r '.[] | select(.address == "'"$win_address"'") | .size[1]')

# Clamp using real window dimensions
max_x=$((mon_x + mon_width - win_w))
max_y=$((mon_y + mon_height - win_h))

x=$((x < mon_x ? mon_x : (x > max_x ? max_x : x)))
y=$((y < mon_y ? mon_y : (y > max_y ? max_y : y)))

hyprctl dispatch setfloating address:$win_address
hyprctl dispatch movewindowpixel exact $x $y,address:$win_address