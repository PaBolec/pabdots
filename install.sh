#!/usr/bin/env bash
# paul's dotfiles installer
# run from inside the cloned repo: ./install.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

echo "==> Dotfiles directory: $DOTFILES_DIR"
echo "==> Backups (if needed) go to: $BACKUP_DIR"

# ---- packages ----
PACKAGES=(hyprland kitty waybar ranger fuzzel dunst swaybg fastfetch fish)

echo "==> Installing packages: ${PACKAGES[*]}"
if command -v pacman &> /dev/null; then
    sudo pacman -S --needed "${PACKAGES[@]}"
else
    echo "pacman not found — install these manually: ${PACKAGES[*]}"
fi

# ---- backup + link helper ----
link_config() {
    local src="$1"
    local dest="$2"

    mkdir -p "$(dirname "$dest")"

    # already correctly linked -> nothing to do
    if [ -L "$dest" ] && [ "$(readlink -f "$dest")" = "$(readlink -f "$src")" ]; then
        echo "  already linked: $dest"
        return
    fi

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        mkdir -p "$BACKUP_DIR/$(dirname "${dest#$HOME/}")"
        echo "  backing up existing $dest"
        mv "$dest" "$BACKUP_DIR/${dest#$HOME/}"
    fi

    ln -s "$src" "$dest"
    echo "  linked $dest -> $src"
}

echo "==> Linking configs"

link_config "$DOTFILES_DIR/hypr/hyprland.conf"        "$HOME/.config/hypr/hyprland.conf"
link_config "$DOTFILES_DIR/kitty/kitty.conf"           "$HOME/.config/kitty/kitty.conf"
link_config "$DOTFILES_DIR/waybar/config"              "$HOME/.config/waybar/config"
link_config "$DOTFILES_DIR/waybar/style.css"           "$HOME/.config/waybar/style.css"
link_config "$DOTFILES_DIR/fastfetch/config.jsonc"     "$HOME/.config/fastfetch/config.jsonc"
link_config "$DOTFILES_DIR/fish/config.fish"           "$HOME/.config/fish/config.fish"

# ---- wallpapers ----
if [ -d "$DOTFILES_DIR/wallpapers" ]; then
    echo "==> Copying wallpapers to ~/Pictures/wallpapers"
    mkdir -p "$HOME/Pictures/wallpapers"
    cp -n "$DOTFILES_DIR"/wallpapers/* "$HOME/Pictures/wallpapers/" 2>/dev/null || true
fi

echo "==> Done."
echo "    Anything that existed before was backed up to: $BACKUP_DIR"
echo "    Reload Hyprland (Super+Shift+Q out and back in, or hyprctl reload) to apply."
