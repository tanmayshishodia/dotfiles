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

        -- Pitch-black high contrast background (replaces vscode's #1e1e1e)
        color_overrides = {
          vscBack = "#000000",
          vscTabCurrent = "#000000",
          vscTabOther = "#000000",
          vscTabOutside = "#000000",
          vscPopupBack = "#000000",
          vscSplitThumb = "#474747",
        },

        group_overrides = {
          -- Cursor and line
          CursorLine    = { bg = "#1a1a1a" },
          CursorLineNr  = { fg = "#ffffff", bold = true },
          LineNr        = { fg = "#858585" },

          -- Selection and search
          Visual        = { bg = "#264f78" },
          VisualNOS     = { bg = "#264f78" },
          Search        = { bg = "#613214", fg = "#ffffff" },
          IncSearch     = { bg = "#ffcc00", fg = "#000000" },

          -- Borders
          VertSplit     = { fg = "#6b6b6b" },
          WinSeparator  = { fg = "#6b6b6b" },
          FloatBorder   = { fg = "#6b6b6b", bg = "#000000" },

          -- Telescope (explicit black bg since it uses its own bg vars)
          TelescopeBorder        = { fg = "#6b6b6b", bg = "#000000" },
          TelescopeNormal        = { bg = "#000000" },
          TelescopePromptBorder  = { fg = "#6b6b6b", bg = "#000000" },
          TelescopeResultsBorder = { fg = "#6b6b6b", bg = "#000000" },
          TelescopePreviewBorder = { fg = "#6b6b6b", bg = "#000000" },

          -- Which-key
          WhichKeyFloat = { bg = "#000000" },

          -- Indent guides
          IblIndent = { fg = "#333333" },
          IblScope  = { fg = "#555555" },
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
