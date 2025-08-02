#!/usr/bin/env bash

install_oh_my_zsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "[dev-tools] Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  else
    echo "[dev-tools] Oh My Zsh already installed."
  fi
}

install_powerlevel10k() {
  local theme_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  if [ ! -d "$theme_dir" ]; then
    echo "[dev-tools] Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$theme_dir"
  else
    echo "[dev-tools] Powerlevel10k already installed."
  fi
}

install_zsh_plugins() {
  local plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

  if [ ! -d "$plugin_dir/zsh-autosuggestions" ]; then
    echo "[dev-tools] Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$plugin_dir/zsh-autosuggestions"
  fi

  if [ ! -d "$plugin_dir/zsh-syntax-highlighting" ]; then
    echo "[dev-tools] Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugin_dir/zsh-syntax-highlighting"
  fi
}

install_nvm() {
  if [ ! -d "$HOME/.nvm" ]; then
    echo "[dev-tools] Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
  else
    echo "[dev-tools] NVM already installed."
  fi
}

install_sdkman() {
  if [ ! -d "$HOME/.sdkman" ]; then
    echo "[dev-tools] Installing SDKMAN..."
    curl -s "https://get.sdkman.io" | bash
  else
    echo "[dev-tools] SDKMAN already installed."
  fi
}

build_neovim() {
  echo "[dev-tools] Building Neovim from source..."
  sudo apt install -y ninja-build gettext cmake unzip curl build-essential

  if [ -d "$HOME/neovim" ]; then
    echo "[dev-tools] Neovim source exists, pulling latest..."
    cd ~/neovim && git pull
  else
    git clone https://github.com/neovim/neovim.git ~/neovim
    cd ~/neovim
  fi

  git checkout stable
  make CMAKE_BUILD_TYPE=Release
  sudo make install
}

install_lazygit() {
  echo "[dev-tools] Installing Lazygit..."
  if ! command -v lazygit >/dev/null 2>&1; then
    LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep tag_name | cut -d '"' -f4)
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm -f lazygit lazygit.tar.gz
  else
    echo "[dev-tools] Lazygit already installed."
  fi
}

build_tmux() {
  echo "[dev-tools] Building Tmux from source..."
  sudo apt install -y automake bison pkg-config libevent-dev libncurses5-dev libncursesw5-dev bc

  if [ -d "$HOME/tmux" ]; then
    echo "[dev-tools] Tmux source exists, pulling latest..."
    cd ~/tmux && git pull
  else
    git clone https://github.com/tmux/tmux.git ~/tmux
    cd ~/tmux
  fi

  sh autogen.sh
  ./configure && make
  sudo make install

  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "[dev-tools] Installing Tmux Plugin Manager (TPM)..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi

  echo "[dev-tools] Tmux plugins will be initialized on first tmux start via TPM."
}

install_nodejs() {
  echo "[dev-tools] Installing Node.js via NVM..."
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install 20
  nvm use 20
}


install_docker() {
  if ! command -v docker >/dev/null 2>&1; then
    echo "[dev-tools] Installing Docker Engine & CLI..."
    sudo apt remove -y docker docker-engine docker.io containerd runc
    sudo apt update
    sudo apt install -y ca-certificates curl gnupg lsb-release

    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    sudo usermod -aG docker "$USER"
    echo "[dev-tools] Docker installed. You may need to re-login for group changes to apply."
  else
    echo "[dev-tools] Docker already installed."
  fi
}

run_dev_tools_module() {
  install_oh_my_zsh
  install_powerlevel10k
  install_zsh_plugins
  install_nvm
  install_sdkman
  build_neovim
  install_lazygit
  build_tmux
  install_nodejs
  # install_docker # Uncomment if you want to install Docker
}

run_dev_tools_module

