#!/usr/bin/env bash

ensure_zsh_installed() {
  if ! command -v zsh >/dev/null 2>&1; then
    echo "[shell] Zsh not found. Installing..."
    if command -v apt >/dev/null 2>&1; then
      sudo apt update && sudo apt install -y zsh
    elif command -v pacman >/dev/null 2>&1; then
      sudo pacman -Sy --noconfirm zsh
    elif command -v dnf >/dev/null 2>&1; then
      sudo dnf install -y zsh
    else
      echo "[shell] Package manager not recognized. Install Zsh manually."
      exit 1
    fi
  fi
}

set_zsh_as_default() {
  if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo "[shell] Changing default shell to Zsh..."
    chsh -s "$(which zsh)"
  fi
}

restart_in_zsh() {
  if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo "[shell] Restarting script in Zsh..."
    exec zsh -c "$0"
  fi
}

run_shell_module() {
  ensure_zsh_installed
  set_zsh_as_default
  restart_in_zsh
}

run_shell_module

