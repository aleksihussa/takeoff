# ----------------------------------
# Powerlevel10k Instant Prompt Setup
# ----------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --------------------
# Environment Variables
# --------------------
export ZSH="$HOME/.oh-my-zsh"

# ----------------------
# Oh My Zsh Configuration
# ----------------------
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

unsetopt CORRECT
# -------------------
# Plugin Configurations
# -------------------
eval $(thefuck --alias)

# Homebrew path setup
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Maven setup
source /etc/profile.d/maven.sh

# -----------------
# Custom Aliases
# -----------------
alias vim="nvim"
alias v="nvim"
alias cds='cd $(find . -type d | fzf)'
alias docker-kill='docker kill $(docker ps -q)'
alias explorer='explorer.exe .'

# -------------------------
# Optional: NVM Setup Block
# -------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Use Node.js v22.14 only in interactive shells
if [[ $- == *i* ]] && ! command -v node >/dev/null || [[ "$(node -v)" != v22.14.* ]]; then
  nvm use 22.14 > /dev/null
fi

# ------------------------
# SDKMAN! Setup (Java, etc.)
# ------------------------
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# -------------------------
# Powerlevel10k prompt load
# -------------------------
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

export DONT_PROMPT_WSL_INSTALL=1
