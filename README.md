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
git clone https://github.com/PaBolec/pabdots.git
cd pabdots
./install.sh

required packages: hyprland kitty waybar ranger fuzzel dunst swaybg fastfetch fish
``` 

Installs the needed packages, backs up any existing configs to
`~/.config-backup-<date>`, then symlinks everything from this repo
into place. Symlinked, not copied — so editing a file in
`~/.config/...` edits the file in this repo directly, meaning you can
`git add`/`commit`/`push` changes any time. Safe to re-run — it skips
anything already correctly linked instead of re-backing it up.

## Update

```bash
./update.sh
```

`git pull` + re-run `install.sh`. For testing changes in a VM: push
from your main machine, then `./update.sh` in the VM to pull and
re-apply.

## Uninstall

```bash
./uninstall.sh            # just removes the symlinks
./uninstall.sh --restore  # also restores the most recent pre-install backup
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
