#!/usr/bin/env bash

CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
THEME="$CFG/rofi/themes/pkg.rasi"

selected=$(paru -Qeq | sort -f | rofi -dmenu -i -theme "$THEME" -p "Packages" || true)

if [[ -n "$selected" ]]; then
  printf '%s' "$selected" | wl-copy
  # optional feedback:
  # notify-send -t 1500 "Copied to clipboard" "$selected"
fi
