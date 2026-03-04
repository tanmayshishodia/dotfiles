#!/bin/bash
# Install CLI tools and dotfiles from offline bundle
# Run this on the air-gapped machine (no sudo required)

set -e

BUNDLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing from offline bundle..."
echo ""

# Create local bin directory
mkdir -p "$HOME/.local/bin"

# Install binaries
echo "Installing CLI tools to ~/.local/bin..."
if [ -d "$BUNDLE_DIR/bin" ]; then
    for binary in "$BUNDLE_DIR/bin"/*; do
        if [ -f "$binary" ]; then
            name=$(basename "$binary")
            cp "$binary" "$HOME/.local/bin/$name"
            chmod +x "$HOME/.local/bin/$name"
            echo "  Installed $name"
        fi
    done
fi

# Install Neovim (has its own directory structure)
if [ -d "$BUNDLE_DIR/nvim" ]; then
    echo "Installing Neovim..."
    rm -rf "$HOME/.local/nvim"
    cp -r "$BUNDLE_DIR/nvim" "$HOME/.local/nvim"
    ln -sf "$HOME/.local/nvim/bin/nvim" "$HOME/.local/bin/nvim"
    echo "  Installed nvim"
fi

# Install dotfiles
if [ -d "$BUNDLE_DIR/dotfiles" ]; then
    echo ""
    echo "Installing dotfiles..."

    DOTFILES_DEST="$HOME/dotfiles"
    if [ -d "$DOTFILES_DEST" ]; then
        echo "  Backing up existing $DOTFILES_DEST to ${DOTFILES_DEST}.backup"
        mv "$DOTFILES_DEST" "${DOTFILES_DEST}.backup"
    fi

    cp -r "$BUNDLE_DIR/dotfiles" "$DOTFILES_DEST"

    # Run dotfiles install script
    cd "$DOTFILES_DEST"
    ./install.sh
fi

echo ""
echo "============================================"
echo "Installation complete!"
echo "============================================"
echo ""
echo "Add this to your ~/.bashrc or ~/.zshrc if not already present:"
echo ""
echo '  export PATH="$HOME/.local/bin:$PATH"'
echo ""
echo "Installed tools:"
ls -1 "$HOME/.local/bin" 2>/dev/null | sed 's/^/  - /'
echo ""
echo "Then restart your shell or run: source ~/.zshrc"
