#!/bin/bash
# Install CLI tools on macOS using Homebrew

set -e

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Installing CLI tools via Homebrew..."

# Modern CLI replacements
brew install eza        # ls replacement
brew install bat        # cat replacement
brew install fd         # find replacement
brew install ripgrep    # grep replacement
brew install dust       # du replacement
brew install btop       # top replacement
brew install lazygit    # git TUI
brew install lazydocker # docker TUI
brew install git-delta  # diff replacement
brew install glances    # system monitor

# Shell enhancements
brew install zoxide     # smart cd
brew install atuin      # better shell history
brew install fzf        # fuzzy finder
brew install direnv     # auto-load .envrc
brew install starship   # prompt

# Zsh plugins
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting

# Optional: Nerd Font for icons
echo ""
echo "Optional: Install a Nerd Font for icons"
echo "  brew install --cask font-meslo-lg-nerd-font"

echo ""
echo "Done! Restart your terminal or run: source ~/.zshrc"
