# Dotfiles

Personal development environment configuration for macOS and Linux.

## What's Included

| Config | Description |
|--------|-------------|
| `wezterm/` | WezTerm terminal (GitHub Dark High Contrast theme, vim-style navigation) |
| `nvim/` | LazyVim with Python IDE setup, fzf-lua, Claude Code integration |
| `zsh/` | Zsh config with modern CLI aliases (eza, bat, fd, rg, etc.) |
| `aerospace/` | macOS tiling window manager with vim-style keybindings |

## Quick Start

```bash
git clone git@github.com:tanmayshishodia/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Then install CLI tools:
```bash
# macOS
./scripts/install-tools-macos.sh

# Linux
./scripts/install-tools-linux.sh
```

## CLI Tools

These aliases are configured in zshrc:

| Alias | Tool | Description |
|-------|------|-------------|
| `ls`, `ll`, `la`, `lt` | eza | Modern ls with icons and git status |
| `cat` | bat | Syntax highlighting |
| `find` | fd | Fast, respects .gitignore |
| `grep` | rg | ripgrep |
| `du` | dust | Visual disk usage |
| `top` | btop | Better process viewer |
| `diff` | delta | Git-aware diff |
| `lg` | lazygit | Git TUI |
| `lzd` | lazydocker | Docker TUI |
| `z` | zoxide | Smart cd |

## WezTerm Keybindings

| Keys | Action |
|------|--------|
| `Cmd+D` | Split horizontal |
| `Cmd+Shift+D` | Split vertical |
| `Cmd+Shift+H/J/K/L` | Navigate panes (vim-style) |
| `Cmd+Ctrl+H/J/K/L` | Resize panes |
| `Cmd+W` | Close pane |
| `Cmd+Z` | Toggle zoom |
| `Cmd+R` | Rename tab |
| `Cmd+1-9` | Switch to tab |
| `Cmd+Shift+F` | Quick select (URLs, hashes) |
| `Cmd+Shift+P` | Command palette |

## Air-Gapped Installation

For machines without internet access, see [scripts/README.md](scripts/README.md).

## Structure

```
dotfiles/
├── aerospace/aerospace.toml
├── nvim/
│   ├── init.lua
│   └── lua/
│       ├── config/
│       └── plugins/
├── wezterm/wezterm.lua
├── zsh/zshrc
├── scripts/
│   ├── install-tools-macos.sh
│   ├── install-tools-linux.sh
│   ├── download-offline-bundle.sh
│   └── install-offline.sh
└── install.sh
```
