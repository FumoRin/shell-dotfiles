# ==============================================================================
# Environment & PATH Configuration (Portable)
# ==============================================================================

# Helper function to prepend a directory to PATH if it exists and isn't already present
prepend_path() {
  if [ -d "$1" ]; then
    case ":$PATH:" in
      *":$1:"*) ;;
      *) export PATH="$1:$PATH" ;;
    esac
  fi
}

# Helper function to append a directory to PATH if it exists and isn't already present
append_path() {
  if [ -d "$1" ]; then
    case ":$PATH:" in
      *":$1:"*) ;;
      *) export PATH="$PATH:$1" ;;
    esac
  fi
}

# Local & user binaries (highest priority)
prepend_path "$HOME/.local/bin"
prepend_path "$HOME/bin"
prepend_path "$HOME/.opencode/bin"

# Go development
prepend_path "$HOME/go/bin"
append_path "/usr/local/go/bin"

# Standalone tools
append_path "/opt/nvim"
append_path "/opt/ghidra"
append_path "$HOME/.linkerd2/bin"
append_path "/snap/bin"

# Service Mesh / Istio (dynamically finds any versioned istio installed)
for istio_bin in "$HOME/.local/bin/istio-"*/bin; do
  [ -d "$istio_bin" ] && append_path "$istio_bin"
done

# Machine Learning / llama.cpp
if [ -d "$HOME/.local/bin/llama.cpp-cuda-12.8" ]; then
  append_path "$HOME/.local/bin/llama.cpp-cuda-12.8"
  export LD_LIBRARY_PATH="$HOME/.local/bin/llama.cpp-cuda-12.8${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
fi

# PNPM
export PNPM_HOME="$HOME/.local/share/pnpm"
prepend_path "$PNPM_HOME"

# Kubernetes config
if [ -f "$HOME/.kube/config" ]; then
  export KUBECONFIG="$HOME/.kube/config"
fi

# Clean up helper functions to keep shell namespace clean
unset -f prepend_path append_path
