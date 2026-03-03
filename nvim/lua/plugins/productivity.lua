-- Fast productivity plugins for LazyVim
return {
  -- ===========================================
  -- Snacks.nvim - QoL collection by folke
  -- (Already included in LazyVim, customize here)
  -- ===========================================
  {
    "folke/snacks.nvim",
    opts = {
      -- Better notifications
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      -- Quick file operations
      quickfile = { enabled = true },
      -- Big file handling (disable slow features)
      bigfile = { enabled = true },
      -- Smooth scrolling
      scroll = { enabled = true },
      -- Word highlighting
      words = { enabled = true },
      -- Zen mode
      zen = { enabled = true },
      -- Git integration
      git = { enabled = true },
      gitbrowse = { enabled = true },
      -- Lazygit integration
      lazygit = {
        enabled = true,
        configure = true, -- auto-configure lazygit for proper Neovim integration
      },
    },
    keys = {
      { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
      -- Lazygit
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit File History" },
      { "<leader>gL", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
      { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss Notifications" },
    },
  },

  -- ===========================================
  -- Flash.nvim - Lightning fast navigation
  -- ===========================================
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      labels = "asdfghjklqwertyuiopzxcvbnm",
      search = {
        multi_window = true,
        forward = true,
        wrap = true,
      },
      jump = {
        autojump = true, -- auto jump when only one match
      },
      modes = {
        char = {
          jump_labels = true,
        },
        search = {
          enabled = true,
        },
      },
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    },
  },

  -- ===========================================
  -- Mini.nvim modules - Fast & minimal
  -- ===========================================
  -- Better around/inside textobjects
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        },
      }
    end,
  },

  -- Fast surround operations
  {
    "nvim-mini/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },

  -- Better f/t motions
  {
    "nvim-mini/mini.jump",
    event = "VeryLazy",
    opts = {
      delay = {
        highlight = 250,
        idle_stop = 10000,
      },
    },
  },

  -- ===========================================
  -- Trouble.nvim v3 - Better diagnostics
  -- ===========================================
  {
    "folke/trouble.nvim",
    opts = {
      focus = true,
      modes = {
        diagnostics = {
          auto_open = false,
          auto_close = true,
        },
      },
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
      { "<leader>xs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
    },
  },

  -- ===========================================
  -- Undotree - Visual undo history
  -- ===========================================
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>U", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" },
    },
  },

  -- ===========================================
  -- Persistence - Session management
  -- ===========================================
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },

  -- ===========================================
  -- Harpoon v2 - Quick file navigation
  -- ===========================================
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
    },
    keys = {
      { "<leader>ha", function() require("harpoon"):list():add() end, desc = "Harpoon Add File" },
      { "<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon Menu" },
      { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon File 1" },
      { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon File 2" },
      { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon File 3" },
      { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon File 4" },
      { "<leader>5", function() require("harpoon"):list():select(5) end, desc = "Harpoon File 5" },
    },
  },

  -- ===========================================
  -- Todo Comments - Highlight TODO/FIXME/etc
  -- ===========================================
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Search Todo" },
    },
  },

  -- ===========================================
  -- Better quickfix
  -- ===========================================
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      preview = {
        winblend = 0,
      },
    },
  },
}
