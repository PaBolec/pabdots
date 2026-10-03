# paul's minimal hyprland dotfiles

Minimal, dwm-inspired Hyprland setup. No blur, no animations, no rounded
corners, flat Nord-ish slate bar.

## Structure

```
hypr/hyprland.lua      - main Hyprland config, Lua syntax (0.55+), no gaps/blur/anims
hypr/hyprland.conf.legacy - old hyprlang .conf, kept for reference only, unused
kitty/kitty.conf        - minimal dark terminal theme
waybar/config           - waybar modules (cpu/ram/gpu/clock/etc)
waybar/style.css        - waybar styling (slate/Nord palette)
fastfetch/config.jsonc  - fastfetch module layout
fish/config.fish        - fish shell config + functions
dwl/config.h            - dwl (suckless Wayland WM) config, voidrice-inspired
dwl/build.sh            - clones + builds dwl and dwlb from source
dwl/start-dwl.sh        - session launcher (bar, wallpaper, bluetooth, dwl)
```

Two WM setups live side by side: **Hyprland** (full-featured, what's
in `hypr/`) and **dwl** (suckless, dwm-for-Wayland, voidrice-inspired
minimalism). Pick whichever at login, or build dwl just to try it —
Hyprland stays untouched either way.

### A note on Hyprland's config format

Hyprland 0.55+ uses Lua configs (`hyprland.lua`) instead of the old
`.conf` (hyprlang) format, which is deprecated and being phased out.
`hypr/hyprland.lua` here is written for that new syntax. If a
dispatcher call in it errors on your installed version, check
[wiki.hypr.land/Configuring/Dispatchers](https://wiki.hypr.land/Configuring/Dispatchers/)
for the current name — the dispatcher API was still settling as of
when this was written.

### A note on dwl

Unlike Hyprland, dwl is suckless software — there's no config file you
drop in while the program is already installed. You edit `config.h`
and **compile** the window manager itself. `dwl/build.sh` automates
cloning dwl + its statusbar (dwlb) and building them with our
`config.h` baked in. If the first build fails, it's almost always a
wlroots version mismatch — check `pacman -Q wlroots` against what
dwl's README expects at the commit `build.sh` pulls, and adjust the
clone branch/tag if needed. This is normal for suckless software, not
a sign something's broken in the script.

dwl keybinds (Super = mod): `Super+Return` terminal, `Super+R` fuzzel,
`Super+E` ranger, `Super+Q` close, `Super+Shift+Q` quit, `Super+J/K`
focus stack, `Super+H/L` resize master, `Super+T/F/M` tile/float/monocle
layouts, `Super+1-9` tags, `Super+B` bluetuith (TUI bluetooth manager).

## Install

```bash
git clone https://github.com/PaBolec/pabdots.git
cd pabdots
./install.sh

required packages: hyprland kitty waybar ranger fuzzel dunst swaybg fastfetch fish
``` 

Installs the needed packages (including bluez/blueman for Bluetooth —
the service gets enabled automatically), backs up any existing configs
to `~/.config-backup-<date>`, then symlinks everything from this repo
into place. Symlinked, not copied — so editing a file in
`~/.config/...` edits the file in this repo directly, meaning you can
`git add`/`commit`/`push` changes any time. Safe to re-run — it skips
anything already correctly linked instead of re-backing it up.

You'll be asked whether to also build dwl — say no if you just want
Hyprland, say yes to build dwl alongside it (takes longer, compiles
from source).

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
