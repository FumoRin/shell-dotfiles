#!/usr/bin/env bash
# ==============================================================================
# Installer / Bootstrap Script for shell-dotfiles
# GitHub: FumoRin/shell-dotfiles
# ==============================================================================

set -e

# Colors
C_RESET='\033[0m'
C_BOLD='\033[1m'
C_GREEN='\033[32m'
C_BLUE='\033[34m'
C_YELLOW='\033[33m'
C_RED='\033[31m'

info() { echo -e "${C_BLUE}${C_BOLD}[INFO]${C_RESET} $*"; }
success() { echo -e "${C_GREEN}${C_BOLD}[OK]${C_RESET} $*"; }
warn() { echo -e "${C_YELLOW}${C_BOLD}[WARN]${C_RESET} $*"; }
error() { echo -e "${C_RED}${C_BOLD}[ERROR]${C_RESET} $*" >&2; }

# Determine script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

INSTALL_DEPS=false
AUTO_YES=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -d|--deps)
      INSTALL_DEPS=true
      shift
      ;;
    -y|--yes)
      AUTO_YES=true
      shift
      ;;
    -h|--help)
      echo "Usage: ./install.sh [options]"
      echo ""
      echo "Options:"
      echo "  -d, --deps     Install system dependencies (zsh, git, curl, fzf) automatically"
      echo "  -y, --yes      Non-interactive mode (assume yes to prompts)"
      echo "  -h, --help     Show this help message"
      exit 0
      ;;
    *)
      warn "Unknown option: $1"
      shift
      ;;
  esac
done

echo -e "${C_BOLD}------------------------------------------------------------${C_RESET}"
echo -e "${C_BOLD}  Installing Terminal Configuration (FumoRin/shell-dotfiles)${C_RESET}"
echo -e "${C_BOLD}------------------------------------------------------------${C_RESET}"

# 1. Install System Dependencies if requested
install_package_manager_deps() {
  info "Checking and installing package dependencies..."
  if command -v dnf &>/dev/null; then
    sudo dnf install -y zsh git curl fzf
  elif command -v apt-get &>/dev/null; then
    sudo apt-get update && sudo apt-get install -y zsh git curl fzf
  elif command -v pacman &>/dev/null; then
    sudo pacman -Sy --noconfirm zsh git curl fzf
  elif command -v zypper &>/dev/null; then
    sudo zypper install -y zsh git curl fzf
  elif command -v apk &>/dev/null; then
    sudo apk add zsh git curl fzf
  elif command -v brew &>/dev/null; then
    brew install zsh git curl fzf
  else
    warn "Unsupported package manager. Please ensure 'zsh', 'git', 'curl', and 'fzf' are installed."
  fi
}

if [ "$INSTALL_DEPS" = true ]; then
  install_package_manager_deps
fi

# Ensure ~/.local/bin exists in current session PATH
mkdir -p "$HOME/.local/bin"
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# 2. Install Oh My Zsh if missing
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
  success "Oh My Zsh installed."
else
  info "Oh My Zsh is already installed."
fi

# 3. Install Oh My Posh if missing
if ! command -v oh-my-posh &>/dev/null; then
  info "Installing Oh My Posh to ~/.local/bin..."
  curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin"
  success "Oh My Posh installed."
else
  info "Oh My Posh is already installed ($(oh-my-posh --version))."
fi

# 4. Helper for safe symlinking
link_file() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"

  if [ -L "$dest" ]; then
    local current_target
    current_target="$(readlink "$dest")"
    if [ "$current_target" = "$src" ]; then
      info "Symlink already valid: $dest -> $src"
      return 0
    else
      info "Updating existing symlink: $dest"
      rm -f "$dest"
    fi
  elif [ -e "$dest" ]; then
    local backup="${dest}.bak_${TIMESTAMP}"
    warn "Existing file found: $dest. Backing up to $backup"
    mv "$dest" "$backup"
  fi

  ln -s "$src" "$dest"
  success "Linked: $dest -> $src"
}

# 5. Link Configuration Files
info "Linking configuration files..."
link_file "$SCRIPT_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_file "$SCRIPT_DIR/.zshenv" "$HOME/.zshenv"
link_file "$SCRIPT_DIR/oh-my-posh" "$HOME/.poshthemes"
link_file "$SCRIPT_DIR/oh-my-posh" "$HOME/.config/oh-my-posh"
link_file "$SCRIPT_DIR/zsh/completions" "$HOME/.config/autocomplete/zsh"

# 6. Check default shell
CURRENT_SHELL="$(basename "$SHELL")"
if [ "$CURRENT_SHELL" != "zsh" ]; then
  ZSH_PATH="$(which zsh 2>/dev/null || true)"
  if [ -n "$ZSH_PATH" ]; then
    info "Default shell is currently $CURRENT_SHELL. To switch to Zsh, run:"
    echo -e "    ${C_BOLD}chsh -s $ZSH_PATH${C_RESET}"
  fi
fi

echo -e "\n${C_GREEN}${C_BOLD}Setup completed successfully!${C_RESET}"
echo -e "Start a new shell or run: ${C_BOLD}exec zsh${C_RESET}"
