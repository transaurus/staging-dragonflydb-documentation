#!/usr/bin/env bash
set -euo pipefail

# Rebuild script for dragonflydb/documentation
# Runs on existing source tree (no clone). Installs deps, runs pre-build steps, builds.

# --- Node version (>=20 required for Docusaurus 3.9.x) ---
export NVM_DIR="${HOME}/.nvm"
if [ ! -f "$NVM_DIR/nvm.sh" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi
# shellcheck source=/dev/null
source "$NVM_DIR/nvm.sh"
nvm install 20
nvm use 20

# --- Ensure yarn is available (scripts in package.json use yarn internally) ---
if ! command -v yarn &>/dev/null; then
    npm install -g yarn
fi

# --- Install dependencies ---
npm install --legacy-peer-deps

# --- Build ---
npm run build

echo "[DONE] Build complete."
