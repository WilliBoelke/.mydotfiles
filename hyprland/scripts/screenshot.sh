#!/usr/bin/env bash
# Simple screenshot script using grim and slurp

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

FILENAME="$SCREENSHOT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"

case "$1" in
    --instant)
        # Full screen screenshot
        grim "$FILENAME"
        notify-send "Screenshot" "Saved to $FILENAME"
        ;;
    --instant-area)
        # Area selection screenshot
        grim -g "$(slurp)" "$FILENAME"
        notify-send "Screenshot" "Saved to $FILENAME"
        ;;
    *)
        # Interactive menu (using anyrun instead of rofi)
        CHOICE=$(echo -e "Full Screen\nSelect Area\nCurrent Window" | anyrun --config-dir ~/.config/anyrun)
        
        case "$CHOICE" in
            "Full Screen")
                grim "$FILENAME"
                ;;
            "Select Area")
                grim -g "$(slurp)" "$FILENAME"
                ;;
            "Current Window")
                grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" "$FILENAME"
                ;;
        esac
        
        [ -f "$FILENAME" ] && notify-send "Screenshot" "Saved to $FILENAME"
        ;;
esac
