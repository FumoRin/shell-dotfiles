# ==============================================================================
# Zsh Configuration File (.zshrc)
# Maintained via GitHub: FumoRin/shell-dotfiles
# ==============================================================================

# Locate Dotfiles Root Directory
if [ -z "$DOTFILES_DIR" ]; then
  if [ -d "$HOME/shell-dotfiles" ]; then
    DOTFILES_DIR="$HOME/shell-dotfiles"
  elif [ -d "$HOME/.dotfiles" ]; then
    DOTFILES_DIR="$HOME/.dotfiles"
  else
    DOTFILES_DIR="$HOME"
  fi
fi

# ------------------------------------------------------------------------------
# 1. Environment & PATH
# ------------------------------------------------------------------------------
if [ -f "$DOTFILES_DIR/zsh/env.zsh" ]; then
  source "$DOTFILES_DIR/zsh/env.zsh"
elif [ -f "$HOME/.shell_common" ]; then
  source "$HOME/.shell_common"
fi

# ------------------------------------------------------------------------------
# 2. Oh My Zsh Framework
# ------------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"

# Theme is managed by Oh My Posh
ZSH_THEME=""

# Plugins
plugins=(
  git
  colored-man-pages
  kubectl
  fzf
)

if [ -f "$ZSH/oh-my-zsh.sh" ]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# ------------------------------------------------------------------------------
# 3. Aliases
# ------------------------------------------------------------------------------
if [ -f "$DOTFILES_DIR/zsh/aliases.zsh" ]; then
  source "$DOTFILES_DIR/zsh/aliases.zsh"
fi

# ------------------------------------------------------------------------------
# 4. Completions
# ------------------------------------------------------------------------------
autoload -Uz colors && colors

# Custom completions
if [ -d "$DOTFILES_DIR/zsh/completions" ]; then
  fpath=("$DOTFILES_DIR/zsh/completions" $fpath)
fi
if [ -d "$HOME/.config/autocomplete/zsh" ]; then
  fpath=("$HOME/.config/autocomplete/zsh" $fpath)
fi

autoload -Uz compinit
compinit -d "${ZDOTDIR:-$HOME}/.zcompdump"

# AWS CLI completion if available
if [ -f "$HOME/.local/bin/aws_completer" ]; then
  complete -C "$HOME/.local/bin/aws_completer" aws 2>/dev/null
fi

# ------------------------------------------------------------------------------
# 5. Prompt (Oh My Posh)
# ------------------------------------------------------------------------------
POSH_THEME=""
if [ -f "$DOTFILES_DIR/oh-my-posh/emodipt-extend.omp.json" ]; then
  POSH_THEME="$DOTFILES_DIR/oh-my-posh/emodipt-extend.omp.json"
elif [ -f "$HOME/.poshthemes/emodipt-extend.omp.json" ]; then
  POSH_THEME="$HOME/.poshthemes/emodipt-extend.omp.json"
elif [ -f "$HOME/.config/oh-my-posh/emodipt-extend.omp.json" ]; then
  POSH_THEME="$HOME/.config/oh-my-posh/emodipt-extend.omp.json"
fi

if command -v oh-my-posh &>/dev/null && [ -n "$POSH_THEME" ]; then
  eval "$(oh-my-posh init zsh --config "$POSH_THEME")"
fi

# ------------------------------------------------------------------------------
# 6. Version Managers & Tools
# ------------------------------------------------------------------------------
# Fast Node Manager (fnm)
if command -v fnm &>/dev/null; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# ------------------------------------------------------------------------------
# 7. Quality of Life & Keybindings
# ------------------------------------------------------------------------------
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line

# ------------------------------------------------------------------------------
# 8. Local Machine Overrides (ignored in Git)
# ------------------------------------------------------------------------------
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
