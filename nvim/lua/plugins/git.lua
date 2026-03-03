-- GitLens-like functionality for LazyVim
return {
  -- ===========================================
  -- Gitsigns - Enable inline blame (built-in)
  -- ===========================================
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      -- Inline blame on current line (like GitLens)
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 300,
        ignore_whitespace = true,
      },
      current_line_blame_formatter = "   <author>, <author_time:%R> • <summary>",
      -- Signs in gutter
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      -- Additional features
      sign_priority = 6,
      update_debounce = 100,
      max_file_length = 40000,
    },
    keys = {
      { "<leader>gB", "<cmd>Gitsigns blame_line full=true<cr>", desc = "Blame Line (full)" },
      { "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle Blame" },
      { "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff This" },
      { "<leader>gD", "<cmd>Gitsigns diffthis ~<cr>", desc = "Diff This ~" },
      { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview Hunk" },
      { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk" },
      { "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset Buffer" },
      { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk" },
      { "<leader>gS", "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage Buffer" },
      { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo Stage Hunk" },
      { "]h", "<cmd>Gitsigns next_hunk<cr>", desc = "Next Hunk" },
      { "[h", "<cmd>Gitsigns prev_hunk<cr>", desc = "Prev Hunk" },
    },
  },

  -- ===========================================
  -- Git-blame.nvim - More GitLens features
  -- ===========================================
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = true,
      message_template = "  <author> • <date> • <summary>",
      date_format = "%r", -- relative time
      virtual_text_column = 80,
      highlight_group = "Comment",
      set_extmark_options = {
        priority = 7,
      },
      display_virtual_text = false, -- use gitsigns for inline, this for statusline
      ignored_filetypes = { "lua", "markdown", "text", "gitcommit", "gitrebase" },
      delay = 500,
    },
    keys = {
      { "<leader>gbt", "<cmd>GitBlameToggle<cr>", desc = "Toggle Git Blame" },
      { "<leader>gbo", "<cmd>GitBlameOpenCommitURL<cr>", desc = "Open Commit URL" },
      { "<leader>gbc", "<cmd>GitBlameCopyCommitURL<cr>", desc = "Copy Commit URL" },
      { "<leader>gbf", "<cmd>GitBlameOpenFileURL<cr>", desc = "Open File URL" },
      { "<leader>gbs", "<cmd>GitBlameCopySHA<cr>", desc = "Copy Commit SHA" },
    },
  },

  -- ===========================================
  -- Diffview - Better diff/merge UI
  -- ===========================================
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>gV", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        merge_tool = {
          layout = "diff3_mixed",
        },
      },
    },
  },

  -- ===========================================
  -- Neogit - Magit-like git interface
  -- ===========================================
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Neogit Commit" },
      { "<leader>gP", "<cmd>Neogit push<cr>", desc = "Neogit Push" },
      { "<leader>gl", "<cmd>Neogit pull<cr>", desc = "Neogit Pull" },
    },
    opts = {
      integrations = {
        diffview = true,
      },
      signs = {
        section = { "", "" },
        item = { "", "" },
      },
    },
  },
}
