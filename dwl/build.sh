#!/usr/bin/env bash
# Clones dwl + dwlb (statusbar), drops in our config.h, builds, installs.
# dwl is suckless software: compiled from source, not a package you just
# install configs into. If the build fails, it's almost always a wlroots
# version mismatch — check `pacman -Q wlroots` against what dwl's README
# expects for the tag/branch we clone below, and adjust if needed.

set -e

DWL_DIR="$HOME/.local/src/dwl"
DWLB_DIR="$HOME/.local/src/dwlb"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing build dependencies"
sudo pacman -S --needed base-devel wayland wayland-protocols wlroots \
    libxkbcommon pixman pkgconf git

echo "==> Cloning dwl"
mkdir -p "$(dirname "$DWL_DIR")"
if [ -d "$DWL_DIR" ]; then
    echo "  dwl already cloned, pulling latest"
    git -C "$DWL_DIR" pull
else
    git clone https://codeberg.org/dwl/dwl.git "$DWL_DIR"
fi

echo "==> Dropping in our config.h"
cp "$DOTFILES_DIR/config.h" "$DWL_DIR/config.h"

echo "==> Building + installing dwl"
cd "$DWL_DIR"
make
sudo make install

echo "==> Cloning dwlb (status bar)"
mkdir -p "$(dirname "$DWLB_DIR")"
if [ -d "$DWLB_DIR" ]; then
    echo "  dwlb already cloned, pulling latest"
    git -C "$DWLB_DIR" pull
else
    git clone https://codeberg.org/dwl/dwlb.git "$DWLB_DIR"
fi

echo "==> Building + installing dwlb"
cd "$DWLB_DIR"
make
sudo make install

echo "==> dwl + dwlb built and installed."
echo "    If this failed with wlroots errors, check:"
echo "      pacman -Q wlroots"
echo "    against the version dwl's README at the cloned commit expects."
