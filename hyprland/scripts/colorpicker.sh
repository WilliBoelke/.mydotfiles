#!/bin/bash

# Check if the color picker is already running
if pgrep -x "hyprpicker" > /dev/null; then
    echo "Color picker is already running."
    exit 1
fi

# run color picker and extract the color code
color_code=$(hyprpicker --autocopy)

# Check if a color code was extracted and notify
if [ -n "$color_code" ]; then
    notify-send "Color Picker" "Color code copied to clipboard: $color_code"
else
    notify-send "Color Picker" "No color code extracted."
fi