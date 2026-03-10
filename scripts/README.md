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

### Option A: Windows VDI → Red Hat VDI (PowerShell)

Use this when you have a Windows machine with internet and need to set up a
Linux machine with no internet. Requires only Git (no WSL, no admin).

**Step 1: On Windows VDI (PowerShell)**
```powershell
cd path\to\dotfiles
powershell -ExecutionPolicy Bypass -File scripts\download-offline-bundle.ps1
```

Creates `dotfiles-offline-bundle-linux-x86_64.zip` containing:
- Linux binary archives (nvim, eza, bat, fd, rg, fzf, zoxide, lazygit, delta, dust, starship, btop, ruff, uv)
- All nvim plugins pre-cloned (lazy.nvim + all 55 plugins from lazy-lock.json)
- Dotfiles
- Install script

**Step 2: Transfer** the `.zip` to the Red Hat machine.

**Step 3: On Red Hat VDI**
```bash
unzip dotfiles-offline-bundle-linux-x86_64.zip
cd dotfiles-offline-bundle-linux-x86_64
bash install-offline.sh
source ~/.bashrc
```

---

### Option B: Linux/macOS → Linux (Bash)

Use this when the internet machine is Linux or macOS.

**Step 1: Create bundle**
```bash
./download-offline-bundle.sh
```

Creates `dotfiles-offline-bundle-linux-x86_64.tar.gz`.

**Step 2: Transfer** the `.tar.gz` to the air-gapped machine.

**Step 3: Install**
```bash
tar -xzf dotfiles-offline-bundle-*.tar.gz
cd dotfiles-offline-bundle-*/
bash install-offline.sh
source ~/.bashrc
```

---

Both options install everything to `~/.local/bin` (no sudo required) and
create an offline nvim config override that disables auto-downloads on startup.
Delete `~/.config/nvim/lua/plugins/offline-overrides.lua` once you have
internet access to restore full functionality.

## Supported Platforms

| OS | Architecture |
|----|--------------|
| Linux | x86_64, aarch64 |
| macOS | x86_64 (Intel), aarch64 (Apple Silicon) |
