# ==============================================================================
# Shell Aliases (Portable across Zsh and Bash)
# ==============================================================================

# Directory listing & Colors
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lsa='ls -lah'
alias grep='grep --color=auto'

# Editor
if command -v nvim &>/dev/null; then
  alias vim='nvim'
  alias vi='nvim'
fi

# Kubernetes
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias ka='kubectl apply -f'
alias kr='kubectl delete -f'
alias ctx='kubectl config current-context'
alias ectx='kubectl config use-context'
alias editctx='kubectl config use-context'

# Quick Navigation & Shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
