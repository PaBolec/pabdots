#!/usr/bin/env bash
# paul's dotfiles updater
# pulls latest from git and re-applies. safe to run anytime — install.sh
# is idempotent, it won't re-backup files that are already linked correctly.
# run from inside the cloned repo: ./update.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

echo "==> Pulling latest from git"
git pull

echo "==> Re-applying install.sh"
./install.sh

echo "==> Update done."
