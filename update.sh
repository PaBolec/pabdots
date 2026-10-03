#!/usr/bin/env bash
# pull the repo and re-run the installer without prompts
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
git pull --ff-only
./install.sh -y
