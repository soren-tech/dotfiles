#!/usr/bin/env bash

# --------------------------------------------------
# Toggle behavior:
# If called with --toggle and the power menu is already open,
# close it instead of opening another one.
# --------------------------------------------------
if [[ "${1:-}" == "--toggle" ]]; then
    if pgrep -f "rofi.*power-menu.rasi" >/dev/null 2>&1; then
        pkill -f "rofi.*power-menu.rasi"
        exit 0
    fi
fi

# Nerd Font Icons
icon_lock=""
icon_logout="󰗼"
icon_suspend=""
icon_reboot="󰜉"
icon_shutdown=""

# Menu Options
opt_lock="$icon_lock  Lock"
opt_logout="$icon_logout  Logout"
opt_suspend="$icon_suspend  Suspend"
opt_reboot="$icon_reboot  Reboot"
opt_shutdown="$icon_shutdown  Shutdown"

options="$opt_lock\n$opt_logout\n$opt_suspend\n$opt_reboot\n$opt_shutdown"

# Launch Rofi
chosen=$(echo -e "$options" | rofi -dmenu -theme "$HOME/.config/rofi/themes/power-menu.rasi" -p "System")

# Execute Commands
case "$chosen" in
    "$opt_lock")
        if command -v hyprlock >/dev/null 2>&1; then
            hyprlock
        else
            loginctl lock-session
        fi
        ;;

    "$opt_logout")
        loginctl terminate-session "$XDG_SESSION_ID"
        ;;

    "$opt_suspend")
        if command -v hyprlock >/dev/null 2>&1; then
            hyprlock &
            sleep 1
            systemctl suspend
        else
            loginctl lock-session
            sleep 1
            systemctl suspend
        fi
        ;;

    "$opt_reboot")
        systemctl reboot
        ;;

    "$opt_shutdown")
        systemctl poweroff
        ;;

    *)
        exit 0
        ;;
esac
