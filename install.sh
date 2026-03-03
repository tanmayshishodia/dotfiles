#!/bin/bash
# Dotfiles installation script
# Creates symlinks from home directory to dotfiles repo

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing dotfiles from $DOTFILES_DIR"

# Backup existing configs
backup_if_exists() {
    if [ -e "$1" ] && [ ! -L "$1" ]; then
        echo "Backing up existing $1 to $1.backup"
        mv "$1" "$1.backup"
    elif [ -L "$1" ]; then
        echo "Removing existing symlink $1"
        rm "$1"
    fi
}

# Zsh
echo "Setting up Zsh..."
backup_if_exists "$HOME/.zshrc"
ln -s "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
echo "  Linked ~/.zshrc"

# WezTerm
echo "Setting up WezTerm..."
backup_if_exists "$HOME/.wezterm.lua"
ln -s "$DOTFILES_DIR/wezterm/wezterm.lua" "$HOME/.wezterm.lua"
echo "  Linked ~/.wezterm.lua"

# Neovim
echo "Setting up Neovim..."
backup_if_exists "$HOME/.config/nvim"
mkdir -p "$HOME/.config"
ln -s "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
echo "  Linked ~/.config/nvim"

# Aerospace
echo "Setting up Aerospace..."
backup_if_exists "$HOME/.aerospace.toml"
ln -s "$DOTFILES_DIR/aerospace/aerospace.toml" "$HOME/.aerospace.toml"
echo "  Linked ~/.aerospace.toml"

echo ""
echo "Done! Dotfiles installed successfully."
echo ""
echo "Next steps:"
echo "  1. Install CLI tools:"
echo "       macOS: ./scripts/install-tools-macos.sh"
echo "       Linux: ./scripts/install-tools-linux.sh"
echo "  2. Restart your terminal or run: source ~/.zshrc"
