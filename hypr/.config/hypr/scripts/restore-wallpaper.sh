#!/bin/sh
# Restore last wallpaper on login (or a default on first boot).
# Runs from hyprland.lua autostart.

# 1. Start the awww daemon (does nothing if already running)
awww-daemon &
sleep 1

# 2. Read the last chosen wallpaper
STATE_FILE="$HOME/.local/state/rofi-wallpaper/last-wallpaper"
W=""
if [ -f "$STATE_FILE" ]; then
    W="$(cat "$STATE_FILE")"
fi

# 3. Fallback: default wallpaper for first boot / missing file
FALLBACK="$HOME/Pictures/Wallpapers/wallpaper.jpg"   # <-- CHANGE THIS if needed
if [ ! -f "$W" ]; then
    W="$FALLBACK"
fi

# 4. Apply it
awww img --transition-type center "$W"
