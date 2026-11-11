# 🐚 Shell & Terminal Dotfiles

Modular, portable terminal configuration featuring **Zsh**, **Oh My Zsh**, and **Oh My Posh**. Designed for lightning-fast setup across different Linux distributions, macOS, and environments.

Part of my dotfiles ecosystem alongside [`tmux-dotfiles`](https://github.com/FumoRin/tmux-dotfiles) and [`neovim-dotfiles`](https://github.com/FumoRin/neovim-dotfiles).

---

## ⚡ Quick Start

### 1. Clone the repository
```bash
git clone https://github.com/FumoRin/shell-dotfiles.git ~/shell-dotfiles
cd ~/shell-dotfiles
```

### 2. Run the installer
```bash
# Standard install (links configs and sets up Oh My Zsh + Oh My Posh if missing):
./install.sh

# Or install system dependencies (zsh, git, curl, fzf) automatically:
./install.sh --deps
```

### 3. Launch Zsh
```bash
exec zsh
```

---

## 📂 Repository Structure

```text
shell-dotfiles/
├── install.sh                  # Bootstrap and symlink installer script
├── .zshenv                     # Global environment initialization (Cargo/Rust)
├── zsh/
│   ├── .zshrc                  # Main shell configuration (OMZ, prompt, QoL)
│   ├── aliases.zsh             # Consolidated aliases (Navigation, Editor, Kubernetes)
│   ├── env.zsh                 # Dynamic, conditional PATH loader
│   └── completions/            # Custom autocompletions (e.g. _tailscale)
└── oh-my-posh/
    ├── emodipt-extend.omp.json # Primary prompt theme
    └── themes/                 # Alternative themes (clean-detailed, cloud-native-azure, etc.)
```

---

## 🚀 Key Features

- **Oh My Zsh Framework**: Configured with core plugins (`git`, `colored-man-pages`, `kubectl`, `fzf`).
- **Customized Oh My Posh Prompt**: Running the extended `emodipt` theme featuring command execution duration, dynamic git branch status, shell identifier, and current path.
- **Dynamic PATH Loader (`env.zsh`)**: Detects existing development tooling on the host machine (`~/.local/bin`, `~/go/bin`, `/opt/nvim`, `/opt/ghidra`, `istio`, `pnpm`, `fnm`, `cargo`) and includes them only when present, keeping `$PATH` clean and fast across different machines.
- **Aliases**:
  - **Listing**: `ls`, `ll` (`ls -alF`), `la` (`ls -A`), `l` (`ls -CF`), `lsa` (`ls -lah`).
  - **Editor**: `vim`, `vi` mapped to `nvim` if installed.
  - **Kubernetes**: `k`, `kg`, `kd`, `ka`, `kr`, `ctx`, `ectx`.
- **Quality of Life**:
  - `Ctrl + x, e` (`^xe`) to edit command-line buffer in `$EDITOR`.
  - Colorized tab autocompletion and AWS CLI autocompletion support.

---

## ⚙️ Machine-Specific Overrides

Need to define private environment variables, corporate cluster kubeconfigs, or custom aliases that shouldn't be committed to version control?

Create a `~/.zshrc.local` file in your home directory:
```bash
# ~/.zshrc.local
export WORK_API_KEY="secret"
alias work-vpn="tailscale up --exit-node=..."
```
This file is automatically sourced at the end of `.zshrc` and is excluded from git.
