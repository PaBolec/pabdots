#!/usr/bin/env bash
# usage: ./uninstall.sh [--restore] [--purge]
#   --restore  put back the most recent ~/.config-backup-* after unlinking
#   --purge    also remove the dwl package and the session entry
set -euo pipefail

DOTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESTORE=0; PURGE=0
for arg in "$@"; do
    case "$arg" in
        --restore) RESTORE=1 ;;
        --purge) PURGE=1 ;;
        *) echo "unknown option: $arg"; exit 1 ;;
    esac
done

unlink_config() {
    local dest="$1"
    if [ -L "$dest" ] && [[ "$(readlink -f "$dest")" == "$DOTS"/* ]]; then
        rm "$dest"; echo "    unlinked $dest"
    fi
}

echo "==> removing symlinks"
for d in kitty fish fastfetch dwl; do
    [ -d "$HOME/.config/$d" ] || continue
    while IFS= read -r -d '' link; do
        unlink_config "$link"
    done < <(find "$HOME/.config/$d" -maxdepth 1 -type l -print0)
done
unlink_config "$HOME/.local/bin/start-dwl.sh"

if [ "$RESTORE" -eq 1 ]; then
    latest=$(ls -dt "$HOME"/.config-backup-* 2>/dev/null | head -n 1 || true)
    if [ -n "$latest" ]; then
        echo "==> restoring $latest"
        cp -a "$latest"/. "$HOME"/
    else
        echo "==> no backup found"
    fi
fi

if [ "$PURGE" -eq 1 ]; then
    echo "==> removing dwl package and session entry"
    sudo pacman -Rns dwl-pab || true
    sudo rm -f /usr/share/wayland-sessions/dwl-session.desktop
    echo "    dwlb was installed to /usr/local, remove with: sudo make -C ~/.local/src/dwlb uninstall"
fi
echo "==> done"
