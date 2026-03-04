#!/bin/bash
# Download all CLI tools for offline installation
# Run this on a machine with internet access

set -e

# Detect OS and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

# Normalize architecture names
case "$ARCH" in
    x86_64|amd64) ARCH="x86_64" ;;
    aarch64|arm64) ARCH="aarch64" ;;
    *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

echo "Detected: $OS $ARCH"
echo ""

# Create bundle directory
BUNDLE_DIR="dotfiles-offline-bundle-${OS}-${ARCH}"
mkdir -p "$BUNDLE_DIR/bin"
cd "$BUNDLE_DIR"

echo "Downloading CLI tools..."

# Helper function to download and extract
download_github_release() {
    local repo="$1"
    local pattern="$2"
    local binary_name="$3"

    echo "  Downloading $binary_name..."
    local url=$(curl -sL "https://api.github.com/repos/$repo/releases/latest" | \
        grep "browser_download_url" | \
        grep -E "$pattern" | \
        head -1 | \
        cut -d '"' -f 4)

    if [ -z "$url" ]; then
        echo "    WARNING: Could not find download for $binary_name"
        return 1
    fi

    local filename=$(basename "$url")
    curl -sLO "$url"

    # Extract based on file type
    case "$filename" in
        *.tar.gz|*.tgz)
            tar -xzf "$filename"
            rm "$filename"
            ;;
        *.zip)
            unzip -q "$filename"
            rm "$filename"
            ;;
        *.tar.xz)
            tar -xJf "$filename"
            rm "$filename"
            ;;
        *)
            # Assume it's a binary
            chmod +x "$filename"
            mv "$filename" "bin/$binary_name"
            return 0
            ;;
    esac

    # Find and move the binary
    find . -maxdepth 3 -name "$binary_name" -type f -exec mv {} "bin/$binary_name" \; 2>/dev/null || \
    find . -maxdepth 3 -type f -executable -name "$binary_name*" -exec mv {} "bin/$binary_name" \; 2>/dev/null || true

    # Cleanup extracted directories
    find . -maxdepth 1 -type d ! -name bin ! -name . -exec rm -rf {} \; 2>/dev/null || true
}

# Platform-specific patterns
if [ "$OS" = "darwin" ]; then
    EZA_PATTERN="eza_.*apple-darwin.tar.gz"
    BAT_PATTERN="bat-.*-${ARCH}-apple-darwin.tar.gz"
    FD_PATTERN="fd-.*-${ARCH}-apple-darwin.tar.gz"
    RG_PATTERN="ripgrep-.*-${ARCH}-apple-darwin.tar.gz"
    FZF_PATTERN="fzf-.*-darwin_$([ "$ARCH" = "x86_64" ] && echo "amd64" || echo "arm64").zip"
    ZOXIDE_PATTERN="zoxide-.*-${ARCH}-apple-darwin.tar.gz"
    LAZYGIT_PATTERN="lazygit_.*_Darwin_$([ "$ARCH" = "x86_64" ] && echo "x86_64" || echo "arm64").tar.gz"
    DELTA_PATTERN="delta-.*-${ARCH}-apple-darwin.tar.gz"
    DUST_PATTERN="dust-.*-${ARCH}-apple-darwin.tar.gz"
    STARSHIP_PATTERN="starship-${ARCH}-apple-darwin.tar.gz"
    BTOP_PATTERN="btop-${ARCH}-macos"
    NVIM_PATTERN="nvim-macos-$([ "$ARCH" = "x86_64" ] && echo "x86_64" || echo "arm64").tar.gz"
else
    EZA_PATTERN="eza_${ARCH}-unknown-linux-gnu.tar.gz"
    BAT_PATTERN="bat-.*-${ARCH}-unknown-linux-gnu.tar.gz"
    FD_PATTERN="fd-.*-${ARCH}-unknown-linux-gnu.tar.gz"
    RG_PATTERN="ripgrep-.*-${ARCH}-unknown-linux-gnu.tar.gz"
    FZF_PATTERN="fzf-.*-linux_$([ "$ARCH" = "x86_64" ] && echo "amd64" || echo "arm64").tar.gz"
    ZOXIDE_PATTERN="zoxide-.*-${ARCH}-unknown-linux-musl.tar.gz"
    LAZYGIT_PATTERN="lazygit_.*_Linux_${ARCH}.tar.gz"
    DELTA_PATTERN="delta-.*-${ARCH}-unknown-linux-gnu.tar.gz"
    DUST_PATTERN="dust-.*-${ARCH}-unknown-linux-gnu.tar.gz"
    STARSHIP_PATTERN="starship-${ARCH}-unknown-linux-gnu.tar.gz"
    BTOP_PATTERN="btop-${ARCH}-linux-musl.tbz"
    NVIM_PATTERN="nvim-linux-${ARCH}.tar.gz"
fi

# Download tools
download_github_release "eza-community/eza" "$EZA_PATTERN" "eza" || true
download_github_release "sharkdp/bat" "$BAT_PATTERN" "bat" || true
download_github_release "sharkdp/fd" "$FD_PATTERN" "fd" || true
download_github_release "BurntSushi/ripgrep" "$RG_PATTERN" "rg" || true
download_github_release "junegunn/fzf" "$FZF_PATTERN" "fzf" || true
download_github_release "ajeetdsouza/zoxide" "$ZOXIDE_PATTERN" "zoxide" || true
download_github_release "jesseduffield/lazygit" "$LAZYGIT_PATTERN" "lazygit" || true
download_github_release "dandavison/delta" "$DELTA_PATTERN" "delta" || true
download_github_release "bootandy/dust" "$DUST_PATTERN" "dust" || true
download_github_release "starship/starship" "$STARSHIP_PATTERN" "starship" || true

# btop (special handling)
echo "  Downloading btop..."
BTOP_URL=$(curl -sL "https://api.github.com/repos/aristocratos/btop/releases/latest" | \
    grep "browser_download_url" | \
    grep -E "$BTOP_PATTERN" | \
    head -1 | \
    cut -d '"' -f 4)
if [ -n "$BTOP_URL" ]; then
    curl -sLO "$BTOP_URL"
    if [[ "$BTOP_URL" == *.tbz ]]; then
        tar -xjf *.tbz 2>/dev/null || true
        find . -name "btop" -type f -exec mv {} bin/btop \; 2>/dev/null || true
        rm -f *.tbz
        rm -rf btop/
    fi
fi

# Neovim
echo "  Downloading neovim..."
NVIM_URL=$(curl -sL "https://api.github.com/repos/neovim/neovim/releases/latest" | \
    grep "browser_download_url" | \
    grep -E "$NVIM_PATTERN" | \
    head -1 | \
    cut -d '"' -f 4)
if [ -n "$NVIM_URL" ]; then
    curl -sLO "$NVIM_URL"
    tar -xzf nvim-*.tar.gz
    mv nvim-*/ nvim/
    rm -f nvim-*.tar.gz
fi

# Make all binaries executable
chmod +x bin/* 2>/dev/null || true

# Copy dotfiles repo
echo ""
echo "Copying dotfiles..."
cd ..
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
cp -r "$DOTFILES_DIR" "$BUNDLE_DIR/dotfiles"
rm -rf "$BUNDLE_DIR/dotfiles/.git"

# Copy install script
cp "$SCRIPT_DIR/install-offline.sh" "$BUNDLE_DIR/"

# Create tarball
echo ""
echo "Creating bundle tarball..."
tar -czf "${BUNDLE_DIR}.tar.gz" "$BUNDLE_DIR"
rm -rf "$BUNDLE_DIR"

echo ""
echo "Done! Bundle created: ${BUNDLE_DIR}.tar.gz"
echo ""
echo "Transfer this file to the air-gapped machine and run:"
echo "  tar -xzf ${BUNDLE_DIR}.tar.gz"
echo "  cd ${BUNDLE_DIR}"
echo "  ./install-offline.sh"
