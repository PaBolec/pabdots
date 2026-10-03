#!/usr/bin/env bash
# pabdots installer: dwl on Arch, wayland only
# usage: ./install.sh [-y] [--remove-hyprland]
#   -y                 no prompts (never removes hyprland unless you also pass the flag)
#   --remove-hyprland  purge hyprland packages and move ~/.config/hypr to the backup dir
set -euo pipefail

DOTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
ASSUME_YES=0
REMOVE_HYPR=0

for arg in "$@"; do
    case "$arg" in
        -y) ASSUME_YES=1 ;;
        --remove-hyprland) REMOVE_HYPR=1 ;;
        *) echo "unknown option: $arg"; exit 1 ;;
    esac
done

[ "$(id -u)" -ne 0 ] || { echo "don't run this as root, it uses sudo when it needs to"; exit 1; }
command -v pacman >/dev/null || { echo "this is for arch, pacman not found"; exit 1; }

# must match what dwl/PKGBUILD depends on. check what arch ships with: pacman -Ss '^wlroots'
WLROOTS_PKG="${WLROOTS_PKG:-wlroots0.19}"

ask() {
    [ "$ASSUME_YES" -eq 1 ] && return 0
    read -rp "$1 [Y/n] " a
    [[ ! "$a" =~ ^[Nn] ]]
}

[ -f "$DOTS/dwl/config.h" ] || { echo "dwl/config.h is missing, copy your config.h into dwl/ first"; exit 1; }
[ -f "$DOTS/dwl/PKGBUILD" ] || { echo "dwl/PKGBUILD is missing"; exit 1; }

echo "==> dotfiles dir: $DOTS"
echo "==> backups (if needed) go to: $BACKUP"

# ---- packages ----
PACKAGES=(
    base-devel git pkgconf
    "$WLROOTS_PKG" wayland wayland-protocols libinput libxkbcommon pixman
    xorg-xwayland libxcb xcb-util-wm          # xwayland for steam/proton, not an x11 session
    mesa vulkan-radeon
    kitty fish ranger fuzzel dunst swaybg fastfetch
    grim slurp wl-clipboard
    xdg-desktop-portal-wlr xdg-desktop-portal-gtk polkit
    bluez bluez-utils pamixer brightnessctl
    ttf-dejavu noto-fonts
)
echo "==> installing packages"
sudo pacman -S --needed "${PACKAGES[@]}"

echo "==> enabling bluetooth"
sudo systemctl enable --now bluetooth.service || true

# bluetuith is AUR only, used by Super+B
if command -v yay >/dev/null; then yay -S --needed bluetuith
elif command -v paru >/dev/null; then paru -S --needed bluetuith
else echo "    no AUR helper, skipping bluetuith"; fi

# ---- hyprland purge ----
purge_hyprland() {
    local pkgs
    pkgs=$(pacman -Qq | grep -E '^(hypr|xdg-desktop-portal-hyprland)' || true)
    if [ -n "$pkgs" ]; then
        echo "    removing: $(echo "$pkgs" | tr '\n' ' ')"
        # shellcheck disable=SC2086
        sudo pacman -Rns $pkgs
    else
        echo "    no hyprland packages installed"
    fi
    if [ -e "$HOME/.config/hypr" ]; then
        mkdir -p "$BACKUP/.config"
        mv "$HOME/.config/hypr" "$BACKUP/.config/hypr"
        echo "    ~/.config/hypr moved to $BACKUP/.config/hypr"
    fi
}

if [ "$REMOVE_HYPR" -eq 1 ]; then
    echo "==> removing hyprland"; purge_hyprland
elif [ "$ASSUME_YES" -eq 0 ] && { pacman -Qq hyprland >/dev/null 2>&1 || [ -e "$HOME/.config/hypr" ]; }; then
    read -rp "==> hyprland is still on this box, purge it? [y/N] " a
    [[ "$a" =~ ^[Yy] ]] && purge_hyprland
fi

# ---- link helper ----
link_config() {
    local src="$1" dest="$2"
    mkdir -p "$(dirname "$dest")"
    if [ -L "$dest" ] && [ "$(readlink -f "$dest")" = "$(readlink -f "$src")" ]; then
        echo "    already linked: $dest"; return
    fi
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        mkdir -p "$BACKUP/$(dirname "${dest#"$HOME"/}")"
        mv "$dest" "$BACKUP/${dest#"$HOME"/}"
        echo "    backed up $dest"
    fi
    ln -s "$src" "$dest"
    echo "    linked $dest"
}

# every top level folder in the repo listed here gets linked into ~/.config/<folder>/
# entry by entry (files and subfolders), whatever they are called. add more names to taste.
# fish_variables is skipped on purpose, fish rewrites it and would break the symlink.
CONFIG_DIRS=(kitty fish fastfetch)

echo "==> linking configs"
for d in "${CONFIG_DIRS[@]}"; do
    [ -d "$DOTS/$d" ] || { echo "    no $d/ in repo, skipping"; continue; }
    while IFS= read -r -d '' entry; do
        name="$(basename "$entry")"
        [ "$name" = "fish_variables" ] && continue
        link_config "$entry" "$HOME/.config/$d/$name"
    done < <(find "$DOTS/$d" -mindepth 1 -maxdepth 1 -print0)
done
link_config "$DOTS/dwl/start-dwl.sh"          "$HOME/.local/bin/start-dwl.sh"
link_config "$DOTS/dwl/autostart.sh"          "$HOME/.config/dwl/autostart.sh"
chmod +x "$DOTS/dwl/start-dwl.sh" "$DOTS/dwl/autostart.sh"

# ---- wallpapers ----
WPDIR="$(find "$DOTS" -maxdepth 1 -type d -iname wallpapers | head -n 1)"
if [ -n "$WPDIR" ]; then
    echo "==> copying wallpapers from $(basename "$WPDIR")/ to ~/Pictures/wallpapers"
    mkdir -p "$HOME/Pictures/wallpapers"
    cp -n "$WPDIR"/* "$HOME/Pictures/wallpapers/" 2>/dev/null || true
fi

# ---- dwl (pacman package built from dwl/PKGBUILD with our config.h) ----
echo "==> building dwl"
( cd "$DOTS/dwl" && makepkg -fsi )

# ---- dwlb (bar) ----
echo "==> building dwlb"
SRC="$HOME/.local/src"; mkdir -p "$SRC"
if [ -d "$SRC/dwlb/.git" ]; then git -C "$SRC/dwlb" pull --ff-only
else git clone --depth 1 https://github.com/kolunmi/dwlb "$SRC/dwlb"; fi
make -C "$SRC/dwlb"
sudo make -C "$SRC/dwlb" install

# ---- login manager session entry ----
echo "==> installing session entry"
sed "s|@HOME@|$HOME|" "$DOTS/dwl/dwl-session.desktop" > /tmp/dwl-session.desktop
sudo install -Dm644 /tmp/dwl-session.desktop /usr/share/wayland-sessions/dwl-session.desktop
rm -f /tmp/dwl-session.desktop

echo
echo "==> done. backups (if any): $BACKUP"
echo "    launch from a tty with: start-dwl.sh   (or pick 'dwl' in your login manager)"
