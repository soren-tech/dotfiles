#!/bin/sh

# Make sure common binary paths are available
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:$PATH"

# Log file for debugging
LOG="${XDG_CACHE_HOME:-$HOME/.cache}/hypr-close-all.log"

exec >>"$LOG" 2>&1

echo "--- $(date '+%Y-%m-%d %H:%M:%S') close-all-windows triggered"

if ! command -v hyprctl >/dev/null 2>&1; then
    echo "ERROR: hyprctl not found"
    exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
    echo "ERROR: jq not found. Install it with: sudo pacman -S jq"
    exit 1
fi

hyprctl clients -j | jq -r '.[].address' | while IFS= read -r addr; do
    case "$addr" in
        ""|null)
            continue
            ;;
    esac

    echo "Closing window address: $addr"

    hyprctl dispatch "hl.dsp.window.close({ window = \"address:$addr\" })"
done
