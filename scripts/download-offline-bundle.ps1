# Download offline bundle for Linux x86_64
# Run this on Windows with internet access (no admin required)
# Requires: Git (for cloning plugins)
#
# Usage: powershell -ExecutionPolicy Bypass -File scripts\download-offline-bundle.ps1

$ErrorActionPreference = "Continue"

# Place bundle OUTSIDE the repo to avoid recursive copy when we include dotfiles
$REPO_ROOT   = Split-Path -Parent $PSScriptRoot
$BUNDLE_NAME = "dotfiles-offline-bundle-linux-x86_64"
$BUNDLE_DIR  = Join-Path (Split-Path -Parent $REPO_ROOT) $BUNDLE_NAME
$ARCHIVES_DIR = Join-Path $BUNDLE_DIR "archives"
$PLUGINS_DIR  = Join-Path $BUNDLE_DIR "nvim-plugins"

Write-Host "Bundle output: $BUNDLE_DIR"
Write-Host "Creating bundle directory..."
New-Item -ItemType Directory -Force -Path $ARCHIVES_DIR | Out-Null
New-Item -ItemType Directory -Force -Path $PLUGINS_DIR | Out-Null

# ---------------------------------------------------------------------------
# Download a GitHub release asset matching a pattern
# ---------------------------------------------------------------------------
function Get-GithubRelease {
    param(
        [string]$Repo,
        [string]$Pattern,
        [string]$OutDir,
        [string]$Label = ""
    )
    $name = if ($Label) { $Label } else { $Repo }
    Write-Host "  Downloading $name..."
    try {
        $release = Invoke-RestMethod `
            -Uri "https://api.github.com/repos/$Repo/releases/latest" `
            -ErrorAction Stop
        $asset = $release.assets |
            Where-Object { $_.name -match $Pattern } |
            Select-Object -First 1
        if ($null -eq $asset) {
            Write-Warning "    No asset matched '$Pattern' in $Repo"
            return
        }
        $outFile = Join-Path $OutDir $asset.name
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $outFile -ErrorAction Stop
        Write-Host "    -> $($asset.name)"
    } catch {
        Write-Warning "    Failed: $_"
    }
}

# ---------------------------------------------------------------------------
# Download Linux x86_64 binary archives
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "==> Downloading Linux binaries..."

# neovim-releases builds target older glibc (works on RHEL 8 / glibc 2.28+)
Get-GithubRelease "neovim/neovim-releases" "nvim-linux-x86_64\.tar\.gz$"               $ARCHIVES_DIR "neovim"
Get-GithubRelease "BurntSushi/ripgrep"     "x86_64-unknown-linux-musl\.tar\.gz$"       $ARCHIVES_DIR "ripgrep"
Get-GithubRelease "sharkdp/fd"             "fd-.*-x86_64-unknown-linux-gnu\.tar\.gz$"  $ARCHIVES_DIR "fd"
Get-GithubRelease "sharkdp/bat"            "bat-.*-x86_64-unknown-linux-gnu\.tar\.gz$" $ARCHIVES_DIR "bat"
Get-GithubRelease "eza-community/eza"      "eza_x86_64-unknown-linux-gnu\.tar\.gz$"    $ARCHIVES_DIR "eza"
Get-GithubRelease "junegunn/fzf"           "fzf-.*-linux_amd64\.tar\.gz$"              $ARCHIVES_DIR "fzf"
Get-GithubRelease "ajeetdsouza/zoxide"     "zoxide-.*-x86_64-unknown-linux-musl\.tar\.gz$" $ARCHIVES_DIR "zoxide"
Get-GithubRelease "jesseduffield/lazygit"  "lazygit_.*_Linux_x86_64\.tar\.gz$"         $ARCHIVES_DIR "lazygit"
Get-GithubRelease "dandavison/delta"       "delta-.*-x86_64-unknown-linux-gnu\.tar\.gz$" $ARCHIVES_DIR "delta"
Get-GithubRelease "bootandy/dust"          "dust-.*-x86_64-unknown-linux-gnu\.tar\.gz$" $ARCHIVES_DIR "dust"
Get-GithubRelease "starship/starship"      "starship-x86_64-unknown-linux-gnu\.tar\.gz$" $ARCHIVES_DIR "starship"
Get-GithubRelease "aristocratos/btop"      "btop-x86_64-unknown-linux-musl\.tbz$"      $ARCHIVES_DIR "btop"
Get-GithubRelease "astral-sh/ruff"         "ruff-x86_64-unknown-linux-gnu\.tar\.gz$"   $ARCHIVES_DIR "ruff"
Get-GithubRelease "astral-sh/uv"           "uv-x86_64-unknown-linux-gnu\.tar\.gz$"     $ARCHIVES_DIR "uv"
Get-GithubRelease "wez/wezterm"            "\.AppImage$"                               $ARCHIVES_DIR "wezterm"

# ---------------------------------------------------------------------------
# Clone nvim plugins (from lazy-lock.json)
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "==> Cloning nvim plugins..."

# Map: lazy-lock.json plugin name -> "owner/repo branch"
# Ordered: lazy.nvim first (plugin manager itself)
$PLUGINS = [ordered]@{
    "lazy.nvim"                      = "folke/lazy.nvim main"
    "LazyVim"                        = "LazyVim/LazyVim main"
    "blink.cmp"                      = "Saghen/blink.cmp main"
    "bufferline.nvim"                = "akinsho/bufferline.nvim main"
    "catppuccin"                     = "catppuccin/nvim main"
    "claudecode.nvim"                = "coder/claudecode.nvim main"
    "conform.nvim"                   = "stevearc/conform.nvim master"
    "diffview.nvim"                  = "sindrets/diffview.nvim main"
    "flash.nvim"                     = "folke/flash.nvim main"
    "friendly-snippets"              = "rafamadriz/friendly-snippets main"
    "fzf-lua"                        = "ibhagwan/fzf-lua main"
    "git-blame.nvim"                 = "f-person/git-blame.nvim main"
    "gitsigns.nvim"                  = "lewis6991/gitsigns.nvim main"
    "grug-far.nvim"                  = "MagicDuck/grug-far.nvim main"
    "harpoon"                        = "ThePrimeagen/harpoon harpoon2"
    "jupytext.nvim"                  = "GCBallesteros/jupytext.nvim main"
    "lazydev.nvim"                   = "folke/lazydev.nvim main"
    "lualine.nvim"                   = "nvim-lualine/lualine.nvim master"
    "mason-lspconfig.nvim"           = "williamboman/mason-lspconfig.nvim main"
    "mason.nvim"                     = "mason-org/mason.nvim main"
    "mini.ai"                        = "echasnovski/mini.ai main"
    "mini.icons"                     = "echasnovski/mini.icons main"
    "mini.jump"                      = "echasnovski/mini.jump main"
    "mini.pairs"                     = "echasnovski/mini.pairs main"
    "mini.surround"                  = "echasnovski/mini.surround main"
    "neo-tree.nvim"                  = "nvim-neo-tree/neo-tree.nvim main"
    "neogen"                         = "danymat/neogen main"
    "neogit"                         = "NeogitOrg/neogit master"
    "neotest"                        = "nvim-neotest/neotest master"
    "neotest-python"                 = "nvim-neotest/neotest-python master"
    "noice.nvim"                     = "folke/noice.nvim main"
    "nui.nvim"                       = "MunifTanjim/nui.nvim main"
    "nvim-bqf"                       = "kevinhwang91/nvim-bqf main"
    "nvim-dap"                       = "mfussenegger/nvim-dap master"
    "nvim-dap-python"                = "mfussenegger/nvim-dap-python master"
    "nvim-lint"                      = "mfussenegger/nvim-lint master"
    "nvim-lspconfig"                 = "neovim/nvim-lspconfig master"
    "nvim-treesitter"                = "nvim-treesitter/nvim-treesitter main"
    "nvim-treesitter-textobjects"    = "nvim-treesitter/nvim-treesitter-textobjects main"
    "nvim-ts-autotag"                = "windwp/nvim-ts-autotag main"
    "nvim-web-devicons"              = "nvim-tree/nvim-web-devicons master"
    "outline.nvim"                   = "hedyhli/outline.nvim main"
    "persistence.nvim"               = "folke/persistence.nvim main"
    "plenary.nvim"                   = "nvim-lua/plenary.nvim master"
    "securemodelines"                = "ciaranm/securemodelines master"
    "snacks.nvim"                    = "folke/snacks.nvim main"
    "telescope.nvim"                 = "nvim-telescope/telescope.nvim master"
    "todo-comments.nvim"             = "folke/todo-comments.nvim main"
    "tokyonight.nvim"                = "folke/tokyonight.nvim main"
    "trouble.nvim"                   = "folke/trouble.nvim main"
    "ts-comments.nvim"               = "folke/ts-comments.nvim main"
    "undotree"                       = "mbbill/undotree master"
    "venv-selector.nvim"             = "linux-cultist/venv-selector.nvim regexp"
    "vscode.nvim"                    = "Mofiqul/vscode.nvim main"
    "which-key.nvim"                 = "folke/which-key.nvim main"
}

$total = $PLUGINS.Count
$i = 0
foreach ($entry in $PLUGINS.GetEnumerator()) {
    $i++
    $name   = $entry.Key
    $parts  = $entry.Value -split " "
    $repo   = $parts[0]
    $branch = $parts[1]
    $dest   = Join-Path $PLUGINS_DIR $name

    Write-Host "  [$i/$total] $name"

    if (Test-Path $dest) {
        Write-Host "    Already cloned, skipping"
        continue
    }

    $result = git clone --depth 1 --branch $branch --quiet `
        "https://github.com/$repo" $dest 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "    Clone failed: $result"
    }
}

# ---------------------------------------------------------------------------
# Copy dotfiles (without .git)
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "==> Copying dotfiles..."
$dotfilesDest = Join-Path $BUNDLE_DIR "dotfiles"

if (Test-Path $dotfilesDest) {
    Remove-Item -Recurse -Force $dotfilesDest
}
New-Item -ItemType Directory -Force $dotfilesDest | Out-Null

# Copy only known dotfiles entries (avoids picking up leftover bundle dirs or
# other junk that may have accumulated inside the repo root)
$itemsToCopy = @("nvim", "zsh", "wezterm", "aerospace", "scripts", "install.sh", "README.md")
foreach ($item in $itemsToCopy) {
    $src = Join-Path $REPO_ROOT $item
    if (Test-Path $src) {
        Copy-Item -Recurse $src $dotfilesDest
    }
}

# ---------------------------------------------------------------------------
# Copy install script to bundle root
# ---------------------------------------------------------------------------
Copy-Item (Join-Path $PSScriptRoot "install-offline.sh") $BUNDLE_DIR

# ---------------------------------------------------------------------------
# Create tar.gz bundle (next to the repo parent directory)
# tar.exe is built into Windows 10+ and handles long paths correctly.
# The result is a proper Linux-compatible archive.
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "==> Creating tar.gz bundle..."
$parentDir  = Split-Path -Parent $REPO_ROOT
$tarPath    = Join-Path $parentDir "$BUNDLE_NAME.tar.gz"
if (Test-Path $tarPath) { Remove-Item $tarPath }

# Run tar from the parent directory so paths inside archive are relative
Push-Location $parentDir
tar -czf "$BUNDLE_NAME.tar.gz" $BUNDLE_NAME
Pop-Location

Remove-Item -Recurse -Force $BUNDLE_DIR

$sizeMB = [math]::Round((Get-Item $tarPath).Length / 1MB, 1)
Write-Host ""
Write-Host "============================================"
Write-Host "Bundle created: $tarPath ($sizeMB MB)"
Write-Host "============================================"
Write-Host ""
Write-Host "Transfer to Red Hat VDI, then run:"
Write-Host "  tar -xzf $BUNDLE_NAME.tar.gz"
Write-Host "  cd $BUNDLE_NAME"
Write-Host "  bash install-offline.sh"
