#!/usr/bin/env bash
# Launches dwl with a status bar, wallpaper, notifications, and bluetooth.
# Put this where your login manager (ly) can call it, or run manually.

WALLPAPER="$HOME/Pictures/wallpapers/wallpaper.jpg"

dwlb -font "monospace 11" &
swaybg -i "$WALLPAPER" -m fill &
dunst &

# Bluetooth: bluetoothd is a systemd service (enable once with
# `sudo systemctl enable --now bluetooth`), this just starts the
# tray/agent side so you get pairing prompts etc.
if command -v blueman-applet &> /dev/null; then
    blueman-applet &
fi

exec dwl
