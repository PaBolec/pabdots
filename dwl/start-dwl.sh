#!/usr/bin/env bash
# session launcher for dwl. run from a tty, or via the login manager entry.
# env vars have to be set here, dwl's -s command can't change dwl's own environment.

export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=dwl
# "wlroots" is what xdg-desktop-portal-wlr listens for
export XDG_CURRENT_DESKTOP=wlroots

export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export ELECTRON_OZONE_PLATFORM_HINT=wayland
export _JAVA_AWT_WM_NONREPARENTING=1

# put ~/.local/bin on PATH in case the shell didn't
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) export PATH="$HOME/.local/bin:$PATH" ;; esac

# dbus session so portals, dunst etc. actually work
if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
    exec dbus-run-session "$0" "$@"
fi

# dwl quits when autostart.sh exits, so that script ends with the bar in the foreground
exec dwl -s "$HOME/.config/dwl/autostart.sh"
