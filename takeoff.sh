#!/usr/bin/env bash

set -e  # Exit on any error

# Resolve absolute path to the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Starting Takeoff from $SCRIPT_DIR..."

# Load modules dynamically using absolute paths
for module in shell base-tools dev-tools dotfiles; do
  MODULE_PATH="$SCRIPT_DIR/modules/$module.sh"
  if [ -f "$MODULE_PATH" ]; then
    echo "[Takeoff] Loading $module module..."
    source "$MODULE_PATH"
  else
    echo "[error] $module.sh not found in modules/" && exit 1
  fi
done

echo ""
echo "✅ All modules loaded successfully!"
echo ""

# Switch to Zsh if not already running
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "[Takeoff] Switching to Zsh..."
  exec zsh -l
fi

