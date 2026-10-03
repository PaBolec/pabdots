# pabdots

dwl on Arch, wayland only, voidrice-inspired minimalism. No hyprland, no bloat.

## Layout

```
dwl/config.h            dwl config, compiled into the compositor
dwl/PKGBUILD            builds dwl with config.h (+ optional patches/) as a pacman package
dwl/patches/            drop *.patch files here, applied in order at build time
dwl/start-dwl.sh        session launcher (env vars, dbus, starts dwl)
dwl/autostart.sh        runs inside dwl: wallpaper, dunst, then dwlb bar
dwl/dwl-session.desktop login manager entry (installed to /usr/share/wayland-sessions)
kitty/ fish/ fastfetch/ terminal, shell, fetch configs
wallpapers/             copied to ~/Pictures/wallpapers
```

## Install

```
git clone https://github.com/PaBolec/pabdots.git
cd pabdots
./install.sh
```

It installs packages, builds dwl and dwlb, symlinks the configs (existing ones get backed
up to `~/.config-backup-<date>`), and installs the session entry. Safe to re-run.

Still got hyprland on the box? `./install.sh --remove-hyprland` purges the packages and
moves `~/.config/hypr` into the backup dir. It only does that when you ask for it.

## Update / uninstall

```
./update.sh                   # git pull + reinstall, no prompts
./uninstall.sh                # remove symlinks
./uninstall.sh --restore      # also restore the latest backup
./uninstall.sh --purge        # also remove the dwl package + session entry
```

## Starting dwl

From a tty run `start-dwl.sh`, or pick "dwl" in your login manager.
To autostart on tty1 with fish, add to `config.fish`:

```fish
if test -z "$WAYLAND_DISPLAY"; and test (tty) = /dev/tty1
    exec start-dwl.sh
end
```

## About dwl

dwl is suckless: config is `config.h`, and changes need a rebuild. Edit `dwl/config.h`,
then `cd dwl && makepkg -fsi` and log out and back in.

- Each dwl release only builds against a specific wlroots version. `pkgver` in
  `dwl/PKGBUILD` and `WLROOTS_PKG` in `install.sh` have to match what Arch ships
  (`pacman -Ss '^wlroots'`). If the build fails, it's almost always this.
- XWayland is built in by default so Steam and Proton games run. It's only a compat
  layer, there is no X11 session. Build pure wayland with `XWAYLAND=0 makepkg -fsi`.
- dwlb only shows tags and layout if dwl is built with the ipc patch
  (put it in `dwl/patches/`). Without it you get the status text only.
- Needs `bluetuith` (AUR) for the Super+B keybind. The installer uses yay/paru if present.

## Keybinds (Super = mod)

`Super+Return` terminal, `Super+R` fuzzel, `Super+E` ranger, `Super+Q` close,
`Super+Shift+Q` quit, `Super+J/K` focus, `Super+H/L` resize master,
`Super+T/F/M` tile/float/monocle, `Super+1-9` tags, `Super+B` bluetuith.
