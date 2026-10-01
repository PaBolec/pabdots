# paul's minimal hyprland dotfiles

Minimal, dwm-inspired Hyprland setup. No blur, no animations, no rounded
corners, flat Nord-ish slate bar.

## Structure

```
hypr/hyprland.conf    - main Hyprland config (keybinds, no gaps/blur/anims)
kitty/kitty.conf       - minimal dark terminal theme
waybar/config          - waybar modules (cpu/ram/gpu/clock/etc)
waybar/style.css       - waybar styling (slate/Nord palette)
```

## Install

```bash
sudo pacman -S hyprland kitty waybar ranger fuzzel dunst swaybg

mkdir -p ~/.config/hypr ~/.config/kitty ~/.config/waybar

cp hypr/hyprland.conf ~/.config/hypr/hyprland.conf
cp kitty/kitty.conf ~/.config/kitty/kitty.conf
cp waybar/config ~/.config/waybar/config
cp waybar/style.css ~/.config/waybar/style.css
```

Edit the `swaybg` line in `hyprland.conf` to point at your own wallpaper.

GPU usage module in waybar assumes an AMD card at `/sys/class/drm/card1/`.
Check with `cat /sys/class/drm/card1/device/gpu_busy_percent` — if that
fails, try `card0` instead and update `waybar/config`.

## Keybinds

- `Super+Return` — terminal
- `Super+E` — file manager (ranger)
- `Super+R` — app launcher (fuzzel)
- `Super+Q` — close window
- `Super+Shift+Q` — exit Hyprland
- `Super+V` — toggle floating
- `Super+F` — fullscreen
- `Super+1-9` — switch workspace
- `Super+Shift+1-9` — move window to workspace
