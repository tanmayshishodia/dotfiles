#!/bin/bash
# Install CLI tools on Linux (Debian/Ubuntu or Fedora/RHEL)

set -e

# Detect package manager
if command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
    INSTALL_CMD="sudo apt install -y"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
    INSTALL_CMD="sudo dnf install -y"
elif command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
    INSTALL_CMD="sudo pacman -S --noconfirm"
else
    echo "Unsupported package manager. Install tools manually."
    exit 1
fi

echo "Detected package manager: $PKG_MANAGER"
echo "Installing CLI tools..."

# Update package list
if [ "$PKG_MANAGER" = "apt" ]; then
    sudo apt update
fi

# Common packages available in most repos
$INSTALL_CMD bat fd-find ripgrep fzf direnv zsh

# Aliases for fd (Debian/Ubuntu names it differently)
if [ "$PKG_MANAGER" = "apt" ]; then
    # fd is named fdfind on Debian/Ubuntu
    mkdir -p ~/.local/bin
    ln -sf $(which fdfind) ~/.local/bin/fd 2>/dev/null || true
fi

# Install tools not in standard repos via cargo/prebuilt binaries
echo ""
echo "Installing tools via cargo/prebuilt binaries..."

# Install cargo if not present
if ! command -v cargo &> /dev/null; then
    echo "Installing Rust/Cargo..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

# Cargo installs
cargo install eza
cargo install du-dust
cargo install git-delta
cargo install zoxide --locked
cargo install atuin
cargo install starship --locked

# Btop (prebuilt or compile)
if [ "$PKG_MANAGER" = "apt" ]; then
    $INSTALL_CMD btop 2>/dev/null || cargo install btop
elif [ "$PKG_MANAGER" = "dnf" ]; then
    $INSTALL_CMD btop
elif [ "$PKG_MANAGER" = "pacman" ]; then
    $INSTALL_CMD btop
fi

# Lazygit
echo "Installing lazygit..."
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm -f lazygit lazygit.tar.gz

# Lazydocker
echo "Installing lazydocker..."
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

# Glances
pip3 install --user glances || $INSTALL_CMD glances

# Zsh plugins
if [ "$PKG_MANAGER" = "apt" ]; then
    $INSTALL_CMD zsh-autosuggestions zsh-syntax-highlighting
elif [ "$PKG_MANAGER" = "dnf" ]; then
    $INSTALL_CMD zsh-autosuggestions zsh-syntax-highlighting
elif [ "$PKG_MANAGER" = "pacman" ]; then
    $INSTALL_CMD zsh-autosuggestions zsh-syntax-highlighting
fi

echo ""
echo "Done! You may need to:"
echo "  1. Add ~/.cargo/bin to your PATH"
echo "  2. Restart your terminal or run: source ~/.zshrc"
echo "  3. Install a Nerd Font for icons"
