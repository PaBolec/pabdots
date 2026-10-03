#!/bin/sh
# runs inside dwl (dwl -s). WAYLAND_DISPLAY exists by now.
# dwl exits when this script exits, so the bar runs in the foreground at the end.

# let portals and dbus activated apps see the wayland display
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE 2>/dev/null

# wallpaper: first image in ~/Pictures/wallpapers
WP=$(find "$HOME/Pictures/wallpapers" -maxdepth 1 -type f 2>/dev/null | sort | head -n 1)
[ -n "$WP" ] && swaybg -i "$WP" -m fill &

dunst &

# bar. needs dwl built with the ipc patch to show tags/layout, otherwise it only shows the status text.
# check flags with: dwlb -h
status() {
    while :; do
        echo "$(date '+%a %d %b %H:%M')"
        sleep 20
    done
}

status | dwlb -ipc -font "monospace:size=10" -status-stdin all
