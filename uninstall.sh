#!/usr/bin/env bash
# paul's dotfiles uninstaller
# removes the symlinks install.sh created, leaves anything else alone.
# run from inside the cloned repo: ./uninstall.sh [--restore]

set -e

TARGETS=(
    "$HOME/.config/hypr/hyprland.conf"
    "$HOME/.config/kitty/kitty.conf"
    "$HOME/.config/waybar/config"
    "$HOME/.config/waybar/style.css"
    "$HOME/.config/fastfetch/config.jsonc"
    "$HOME/.config/fish/config.fish"
)

echo "==> Removing symlinks created by install.sh"

for dest in "${TARGETS[@]}"; do
    if [ -L "$dest" ]; then
        rm "$dest"
        echo "  removed $dest"
    elif [ -e "$dest" ]; then
        echo "  skipping $dest (exists but isn't a symlink, leaving it alone)"
    else
        echo "  skipping $dest (doesn't exist)"
    fi
done

echo
if [ "$1" = "--restore" ]; then
    LATEST=$(ls -dt "$HOME"/.config-backup-* 2>/dev/null | head -n1)
    if [ -z "$LATEST" ]; then
        echo "No backup folder found, nothing to restore."
        exit 0
    fi
    echo "==> Restoring from $LATEST"
    cp -r "$LATEST"/. "$HOME/.config/"
    echo "    Restored."
else
    echo "==> Symlinks removed."
    echo "    Pre-dotfiles configs (if any existed) are backed up under:"
    ls -d "$HOME"/.config-backup-* 2>/dev/null || echo "    (no backup folders found)"
    echo "    Run './uninstall.sh --restore' to auto-restore the most recent one."
fi
