#!/usr/bin/env bash

backup_and_symlink() {
  local src=$1
  local dest=$2

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "[dotfiles] Backing up existing $dest to $dest.bak"
    mv "$dest" "$dest.bak"
  fi

  echo "[dotfiles] Symlinking $src -> $dest"
  ln -s "$src" "$dest"
}

setup_zsh_dotfiles() {
  echo "[dotfiles] Setting up Zsh dotfiles..."
  mkdir -p "$HOME/.config/zsh"
  backup_and_symlink "$(pwd)/dotfiles/.zshrc" "$HOME/.zshrc"
  backup_and_symlink "$(pwd)/dotfiles/.p10k.zsh" "$HOME/.p10k.zsh"

  echo "[dotfiles] Verifying Oh My Zsh & plugins..."
  local omz_dir="$HOME/.oh-my-zsh"
  local theme_dir="${ZSH_CUSTOM:-$omz_dir/custom}/themes/powerlevel10k"
  local plugins_dir="${ZSH_CUSTOM:-$omz_dir/custom}/plugins"

  if [ ! -d "$omz_dir" ]; then
    echo "[WARNING] Oh My Zsh is not installed!"
  fi
  if [ ! -d "$theme_dir" ]; then
    echo "[WARNING] Powerlevel10k theme not found in $theme_dir!"
  fi
  if [ ! -d "$plugins_dir/zsh-autosuggestions" ]; then
    echo "[WARNING] zsh-autosuggestions plugin missing!"
  fi
  if [ ! -d "$plugins_dir/zsh-syntax-highlighting" ]; then
    echo "[WARNING] zsh-syntax-highlighting plugin missing!"
  fi
}

setup_neovim() {
  echo "[dotfiles] Setting up Neovim config..."
  local nvim_config_dir="$HOME/.config/nvim"

  if [ -d "$nvim_config_dir" ]; then
    echo "[dotfiles] Backing up existing Neovim config..."
    mv "$nvim_config_dir" "$nvim_config_dir.bak"
  fi

  git clone https://github.com/aleksihussa/nvim.git "$nvim_config_dir"
}

setup_tmux() {
  echo "[dotfiles] Setting up Tmux config..."
  local tmux_config_dir="$HOME/.config/tmux"

  if [ -d "$tmux_config_dir" ]; then
    echo "[dotfiles] Backing up existing Tmux config..."
    mv "$tmux_config_dir" "$tmux_config_dir.bak"
  fi

  git clone https://github.com/aleksihussa/tmuxConfig.git "$tmux_config_dir"

  # Symlink .tmux.conf if needed
  if [ -f "$tmux_config_dir/.tmux.conf" ]; then
    backup_and_symlink "$tmux_config_dir/.tmux.conf" "$HOME/.tmux.conf"
  fi
}

run_dotfiles_module() {
  setup_zsh_dotfiles
  setup_neovim
  setup_tmux
}

run_dotfiles_module

