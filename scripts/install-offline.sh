#!/bin/bash
# Install CLI tools, neovim, and dotfiles from offline bundle
# Run this on the air-gapped machine (no sudo required)
#
# Supports two bundle formats:
#   - PowerShell bundle: archives/ + nvim-plugins/ directories
#   - Bash bundle:       bin/ + nvim/ directories (pre-extracted)

set -e

BUNDLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_BIN="$HOME/.local/bin"
LOCAL_SHARE="$HOME/.local/share/nvim/lazy"

mkdir -p "$LOCAL_BIN"
mkdir -p "$LOCAL_SHARE"

echo "Installing from bundle: $BUNDLE_DIR"
echo ""

# ---------------------------------------------------------------------------
# Helper: find and copy a binary from an extracted directory
# ---------------------------------------------------------------------------
install_binary() {
    local name="$1"
    local search_dir="$2"
    local binary
    binary=$(find "$search_dir" -maxdepth 4 -type f -name "$name" 2>/dev/null | head -1)
    if [ -n "$binary" ]; then
        cp "$binary" "$LOCAL_BIN/$name"
        chmod +x "$LOCAL_BIN/$name"
        echo "  Installed $name"
    else
        echo "  WARNING: $name not found in extracted archive"
    fi
}

# ---------------------------------------------------------------------------
# FORMAT A: PowerShell bundle (archives/ directory with raw .tar.gz files)
# ---------------------------------------------------------------------------
if [ -d "$BUNDLE_DIR/archives" ]; then
    echo "==> Extracting and installing CLI tools..."
    WORK_DIR="$(mktemp -d)"
    trap 'rm -rf "$WORK_DIR"' EXIT

    for archive in "$BUNDLE_DIR/archives"/*; do
        [ -f "$archive" ] || continue
        filename="$(basename "$archive")"
        extract_dir="$WORK_DIR/${filename%%.*}"
        mkdir -p "$extract_dir"

        case "$filename" in
            *.tar.gz|*.tgz)  tar -xzf "$archive" -C "$extract_dir" ;;
            *.tar.xz)        tar -xJf "$archive" -C "$extract_dir" ;;
            *.tbz|*.tar.bz2) tar -xjf "$archive" -C "$extract_dir" ;;
            *.zip)           unzip -q "$archive" -d "$extract_dir" ;;
            *)               cp "$archive" "$extract_dir/" ;;
        esac

        case "$filename" in
            nvim-*.tar.gz)
                echo "  Installing neovim..."
                nvim_bin=$(find "$extract_dir" -maxdepth 4 -name "nvim" -type f 2>/dev/null | head -1)
                if [ -n "$nvim_bin" ]; then
                    nvim_root=$(dirname "$(dirname "$nvim_bin")")
                    rm -rf "$HOME/.local/nvim"
                    cp -r "$nvim_root" "$HOME/.local/nvim"
                    ln -sf "$HOME/.local/nvim/bin/nvim" "$LOCAL_BIN/nvim"
                    echo "  Installed nvim"
                else
                    echo "  WARNING: nvim binary not found in archive"
                fi
                ;;
            ripgrep-*) install_binary "rg"       "$extract_dir" ;;
            fd-*)      install_binary "fd"        "$extract_dir" ;;
            bat-*)     install_binary "bat"       "$extract_dir" ;;
            eza_*)     install_binary "eza"       "$extract_dir" ;;
            fzf-*)     install_binary "fzf"       "$extract_dir" ;;
            zoxide-*)  install_binary "zoxide"    "$extract_dir" ;;
            lazygit_*) install_binary "lazygit"   "$extract_dir" ;;
            delta-*)   install_binary "delta"     "$extract_dir" ;;
            dust-*)    install_binary "dust"      "$extract_dir" ;;
            starship-*)install_binary "starship"  "$extract_dir" ;;
            btop-*)    install_binary "btop"      "$extract_dir" ;;
            ruff-*)    install_binary "ruff"      "$extract_dir" ;;
            uv-*)      install_binary "uv"        "$extract_dir" ;;
            WezTerm-*.AppImage|wezterm*.AppImage)
                echo "  Installing WezTerm (AppImage)..."
                appimage="$BUNDLE_DIR/archives/$filename"
                chmod +x "$appimage"
                rm -rf "$HOME/.local/wezterm-squashfs"
                cd "$HOME/.local" && "$appimage" --appimage-extract >/dev/null 2>&1
                mv "$HOME/.local/squashfs-root" "$HOME/.local/wezterm-squashfs"
                ln -sf "$HOME/.local/wezterm-squashfs/usr/bin/wezterm" "$LOCAL_BIN/wezterm"
                echo "  Installed wezterm (extracted to ~/.local/wezterm-squashfs)"
                ;;
        esac
    done

# ---------------------------------------------------------------------------
# FORMAT B: Bash bundle (pre-extracted bin/ and nvim/ directories)
# ---------------------------------------------------------------------------
elif [ -d "$BUNDLE_DIR/bin" ]; then
    echo "==> Installing CLI tools from bin/..."
    for binary in "$BUNDLE_DIR/bin"/*; do
        [ -f "$binary" ] || continue
        name=$(basename "$binary")
        cp "$binary" "$LOCAL_BIN/$name"
        chmod +x "$LOCAL_BIN/$name"
        echo "  Installed $name"
    done

    if [ -d "$BUNDLE_DIR/nvim" ]; then
        echo "Installing Neovim..."
        rm -rf "$HOME/.local/nvim"
        cp -r "$BUNDLE_DIR/nvim" "$HOME/.local/nvim"
        ln -sf "$HOME/.local/nvim/bin/nvim" "$LOCAL_BIN/nvim"
        echo "  Installed nvim"
    fi
fi

# ---------------------------------------------------------------------------
# Install nvim plugins (pre-cloned from PowerShell bundle)
# ---------------------------------------------------------------------------
if [ -d "$BUNDLE_DIR/nvim-plugins" ]; then
    echo ""
    echo "==> Installing nvim plugins to $LOCAL_SHARE..."
    count=0
    for plugin_dir in "$BUNDLE_DIR/nvim-plugins"/*/; do
        [ -d "$plugin_dir" ] || continue
        name=$(basename "$plugin_dir")
        dest="$LOCAL_SHARE/$name"
        if [ -d "$dest" ]; then
            rm -rf "$dest"
        fi
        cp -r "$plugin_dir" "$dest"
        count=$((count + 1))
    done
    echo "  Installed $count plugins"
fi

# ---------------------------------------------------------------------------
# Create offline Lua overrides
# Disables auto-downloading treesitter parsers and mason packages
# so nvim starts cleanly without internet.
# ---------------------------------------------------------------------------
if [ -d "$BUNDLE_DIR/nvim-plugins" ]; then
    echo ""
    echo "==> Creating offline nvim overrides..."
    NVIM_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
    mkdir -p "$NVIM_CONFIG/lua/plugins"

    cat > "$NVIM_CONFIG/lua/plugins/offline-overrides.lua" << 'EOF'
-- Created by install-offline.sh
-- Disables network-dependent auto-installs so nvim starts cleanly offline.
-- Safe to delete once you have internet access and want to restore full functionality.
return {
  -- Disable treesitter auto-installing parsers (requires internet + gcc)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {},
      auto_install = false,
    },
  },
  -- Disable mason auto-installing LSP tools
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {},
    },
  },
  -- Disable lazy.nvim update checker (avoids network errors on startup)
  {
    "folke/lazy.nvim",
    opts = {
      checker = { enabled = false },
    },
  },
}
EOF
    echo "  Created lua/plugins/offline-overrides.lua"
    echo "  (Delete this file once you have internet access)"
fi

# ---------------------------------------------------------------------------
# Install dotfiles
# ---------------------------------------------------------------------------
if [ -d "$BUNDLE_DIR/dotfiles" ]; then
    echo ""
    echo "==> Installing dotfiles..."
    DOTFILES_DEST="$HOME/dotfiles"
    if [ -d "$DOTFILES_DEST" ]; then
        echo "  Backing up $DOTFILES_DEST -> ${DOTFILES_DEST}.backup"
        mv "$DOTFILES_DEST" "${DOTFILES_DEST}.backup"
    fi
    cp -r "$BUNDLE_DIR/dotfiles" "$DOTFILES_DEST"
    cd "$DOTFILES_DEST"
    bash install.sh
fi

# ---------------------------------------------------------------------------
# PATH setup
# ---------------------------------------------------------------------------
echo ""
echo "============================================"
echo "Installation complete!"
echo "============================================"
echo ""

# Check if PATH already includes ~/.local/bin
if ! grep -q 'LOCAL.*bin\|\.local/bin' "${HOME}/.bashrc" 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    echo "Added ~/.local/bin to PATH in ~/.bashrc"
fi

echo ""
echo "Installed tools:"
ls -1 "$LOCAL_BIN" 2>/dev/null | sed 's/^/  /'
echo ""
echo "Next steps:"
echo "  1. Run: source ~/.bashrc  (or restart shell)"
echo "  2. Run: nvim              (first launch installs lazy.nvim UI, may show warnings)"
echo "  3. In nvim, run: :Lazy    (verify plugins loaded)"
echo ""
echo "Notes:"
echo "  - Treesitter parsers are disabled offline (no syntax highlighting)"
echo "  - Mason LSP tools (ruff, debugpy) need to be installed manually:"
echo "      ruff: already in ~/.local/bin if downloaded"
echo "      debugpy: pip install debugpy"
echo "  - ty (Python LSP): install from https://github.com/astral-sh/ty/releases"
echo "    and ensure 'ty' is in PATH"
echo "  - To restore full functionality: delete ~/.config/nvim/lua/plugins/offline-overrides.lua"
