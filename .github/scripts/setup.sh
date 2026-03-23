#!/bin/bash
set -e

# Setup for dragonflydb/documentation
# Docusaurus 3.9.2, Node >= 20, yarn

REPO_URL="https://github.com/dragonflydb/documentation"
CLONE_DIR="source-repo"

# Load nvm
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh"
fi

# Ensure Node 20
nvm install 20
nvm use 20

node --version
npm --version

# Enable corepack and use yarn
corepack enable || true
npm install -g yarn || true

yarn --version

# Clone repo
git clone --depth=1 "$REPO_URL" "$CLONE_DIR"
cd "$CLONE_DIR"

# Install dependencies
yarn install --frozen-lockfile

# Run write-translations
yarn run docusaurus write-translations

echo "SUCCESS: write-translations completed"

# Build the site
# Note: build fetches DRAGONFLY_VERSION from https://version.dragonflydb.io/v1 at build time
yarn run build

# Verify build output
if [ -d "build" ] && [ -n "$(ls -A build)" ]; then
  echo "SUCCESS: build completed, output in build/"
else
  echo "ERROR: build failed - no output in build/"
  exit 1
fi
