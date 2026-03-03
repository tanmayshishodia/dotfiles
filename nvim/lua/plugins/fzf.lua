-- Enable fzf-lua as the picker (faster than Telescope)
return {
  -- Import LazyVim fzf extra (replaces Telescope)
  { import = "lazyvim.plugins.extras.editor.fzf" },

  -- Optional: customize fzf-lua settings
  {
    "ibhagwan/fzf-lua",
    opts = {
      -- Use a dark borderless UI
      winopts = {
        height = 0.85,
        width = 0.80,
        preview = {
          layout = "vertical",
          vertical = "down:50%",
        },
      },
      -- Faster file finding
      files = {
        fd_opts = "--color=never --type f --hidden --follow --exclude .git",
      },
      grep = {
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096",
      },
    },
  },
}
