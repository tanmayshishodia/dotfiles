# Scripts

## Online Installation

### macOS
```bash
./install-tools-macos.sh
```
Installs all CLI tools via Homebrew.

### Linux
```bash
./install-tools-linux.sh
```
Installs via apt/dnf/pacman + cargo for tools not in repos.

## Air-Gapped Installation

For machines without internet access and without sudo.

### Step 1: Create Bundle (on internet machine)

```bash
./download-offline-bundle.sh
```

Creates `dotfiles-offline-bundle-<os>-<arch>.tar.gz` containing:
- Pre-built binaries (eza, bat, fd, rg, fzf, zoxide, lazygit, delta, dust, starship, btop, nvim)
- Dotfiles
- Install script

### Step 2: Transfer

Copy the tarball to the air-gapped machine via USB, scp, or file share.

### Step 3: Install (on air-gapped machine)

```bash
tar -xzf dotfiles-offline-bundle-*.tar.gz
cd dotfiles-offline-bundle-*/
./install-offline.sh
```

Installs everything to `~/.local/bin` (no sudo required).

### Step 4: Update PATH

Add to `~/.bashrc` or `~/.zshrc`:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Supported Platforms

| OS | Architecture |
|----|--------------|
| Linux | x86_64, aarch64 |
| macOS | x86_64 (Intel), aarch64 (Apple Silicon) |
