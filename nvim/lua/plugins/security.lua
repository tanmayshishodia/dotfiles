-- Security hardening for Neovim
return {
  -- Disable modelines (historical attack vector)
  {
    "LazyVim/LazyVim",
    opts = function()
      vim.opt.modeline = false
      vim.opt.modelines = 0
    end,
  },

  -- Securemodelines - safe alternative to modelines
  {
    "ciaranm/securemodelines",
    lazy = false,
    init = function()
      vim.g.secure_modelines_allowed_items = {
        "textwidth", "tw",
        "softtabstop", "sts",
        "tabstop", "ts",
        "shiftwidth", "sw",
        "expandtab", "et", "noexpandtab", "noet",
        "filetype", "ft",
        "foldmethod", "fdm",
        "foldlevel", "fdl",
        "readonly", "ro", "noreadonly", "noro",
        "rightleft", "rl", "norightleft", "norl",
        "spell",
        "spelllang",
        "wrap", "nowrap",
      }
    end,
  },
}
