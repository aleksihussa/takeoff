#!/usr/bin/env bash

set -e  # Exit on any error

echo "🚀 Starting Takeoff..."

# Ensure script is run from its directory
cd "$(dirname "$0")"

# Load modules
if [ -f modules/shell.sh ]; then
  source modules/shell.sh
else
  echo "[error] shell.sh not found!" && exit 1
fi

if [ -f modules/base-tools.sh ]; then
  source modules/base-tools.sh
else
  echo "[error] base-tools.sh not found!" && exit 1
fi

if [ -f modules/dev-tools.sh ]; then
  source modules/dev-tools.sh
else
  echo "[error] dev-tools.sh not found!" && exit 1
fi

if [ -f modules/dotfiles.sh ]; then
  source modules/dotfiles.sh
else
  echo "[error] dotfiles.sh not found!" && exit 1
fi

if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Switching to Zsh..."
  exec zsh -l
fi
