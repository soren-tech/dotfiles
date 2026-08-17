#!/usr/bin/env bash

STATE_FILE="/tmp/sw_state"
ELAPSED_FILE="/tmp/sw_elapsed"
START_FILE="/tmp/sw_start"

get_elapsed() {
    [ -f "$ELAPSED_FILE" ] && cat "$ELAPSED_FILE" || echo 0
}

get_state() {
    [ -f "$STATE_FILE" ] && cat "$STATE_FILE" || echo "paused"
}

format_time() {
    local total_seconds=$1
    local hours=$((total_seconds / 3600))
    local minutes=$(( (total_seconds % 3600) / 60 ))
    local seconds=$((total_seconds % 60))
    
    if [ $hours -gt 0 ]; then
        printf " %02d:%02d:%02d" $hours $minutes $seconds
    else
        printf " %02d:%02d" $minutes $seconds
    fi
}

case "$1" in
    toggle)
        STATE=$(get_state)
        NOW=$(date +%s)
        if [ "$STATE" = "running" ]; then
            START=$(cat "$START_FILE")
            ELAPSED=$(get_elapsed)
            NEW_ELAPSED=$((ELAPSED + NOW - START))
            echo "$NEW_ELAPSED" > "$ELAPSED_FILE"
            echo "paused" > "$STATE_FILE"
        else
            echo "$NOW" > "$START_FILE"
            echo "running" > "$STATE_FILE"
        fi
        pkill -RTMIN+8 waybar
        ;;
    reset)
        echo "paused" > "$STATE_FILE"
        echo "0" > "$ELAPSED_FILE"
        rm -f "$START_FILE"
        pkill -RTMIN+8 waybar
        ;;
    status)
        STATE=$(get_state)
        ELAPSED=$(get_elapsed)
        if [ "$STATE" = "running" ]; then
            START=$(cat "$START_FILE")
            NOW=$(date +%s)
            TOTAL=$((ELAPSED + NOW - START))
            format_time "$TOTAL"
        else
            format_time "$ELAPSED"
        fi
        ;;
esac
