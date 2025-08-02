#!/usr/bin/env bash

install_apt_packages() {
  echo "[base-tools] Installing base packages via apt..."
  sudo apt update
  sudo apt install -y git unzip zip curl wget ripgrep fzf tmux build-essential
}

install_pacman_packages() {
  echo "[base-tools] Installing base packages via pacman..."
  sudo pacman -Sy --noconfirm git zip unzip curl wget ripgrep fzf tmux base-devel
}

install_dnf_packages() {
  echo "[base-tools] Installing base packages via dnf..."
  sudo dnf install -y git curl wget zip unzip ripgrep fzf tmux @development-tools
}

install_base_tools() {
  if command -v apt >/dev/null 2>&1; then
    install_apt_packages
  elif command -v pacman >/dev/null 2>&1; then
    install_pacman_packages
  elif command -v dnf >/dev/null 2>&1; then
    install_dnf_packages
  else
    echo "[base-tools] Unsupported package manager. Please install packages manually."
  fi
}

install_base_tools

