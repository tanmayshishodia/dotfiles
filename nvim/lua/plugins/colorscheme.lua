return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vscode").setup({
        transparent = false,
        italic_comments = false,
        italic_inlayhints = false,
        terminal_colors = true,

        color_overrides = {
          vscBack = "#000000",
        },
      })
      vim.cmd.colorscheme("vscode")
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "vscode" },
  },
}
