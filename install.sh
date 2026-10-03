#!/usr/bin/env bash
# paul's dotfiles installer
# run from inside the cloned repo: ./install.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

echo "==> Dotfiles directory: $DOTFILES_DIR"
echo "==> Backups (if needed) go to: $BACKUP_DIR"

# ---- packages ----
PACKAGES=(hyprland kitty waybar ranger fuzzel dunst swaybg fastfetch fish \
    bluez bluez-utils blueman pamixer brightnessctl)

echo "==> Installing packages: ${PACKAGES[*]}"
if command -v pacman &> /dev/null; then
    sudo pacman -S --needed "${PACKAGES[@]}"
else
    echo "pacman not found — install these manually: ${PACKAGES[*]}"
fi

echo "==> Enabling bluetooth service"
sudo systemctl enable --now bluetooth.service || true

# bluetuith is AUR-only (TUI bluetooth manager used in dwl keybind) —
# install with yay/paru if you have one, otherwise skip, blueman still works
if command -v yay &> /dev/null; then
    yay -S --needed bluetuith
elif command -v paru &> /dev/null; then
    paru -S --needed bluetuith
else
    echo "  no AUR helper found — skipping bluetuith (blueman-applet still installed)"
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

link_config "$DOTFILES_DIR/hypr/hyprland.lua"          "$HOME/.config/hypr/hyprland.lua"
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

# ---- dwl (optional, compiled from source) ----
echo
echo "==> dwl is suckless software — compiled from source, not just configs."
read -p "    Build and install dwl now? [y/N] " BUILD_DWL
if [[ "$BUILD_DWL" =~ ^[Yy]$ ]]; then
    "$DOTFILES_DIR/dwl/build.sh"
    mkdir -p "$HOME/.local/bin"
    link_config "$DOTFILES_DIR/dwl/start-dwl.sh" "$HOME/.local/bin/start-dwl.sh"
    chmod +x "$HOME/.local/bin/start-dwl.sh" 2>/dev/null || true
    echo "  dwl built. Launch with: start-dwl.sh (from a TTY, or point your"
    echo "  login manager's session entry at it)."
else
    echo "  skipped dwl build — Hyprland setup still applies, dwl stays"
    echo "  available in dwl/ whenever you want to build it (./dwl/build.sh)."
fi

echo "==> Done."
echo "    Anything that existed before was backed up to: $BACKUP_DIR"
echo "    Reload Hyprland (Super+Shift+Q out and back in, or hyprctl reload) to apply."
