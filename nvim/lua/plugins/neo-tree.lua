return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
    window = {
      mappings = {
        ["Y"] = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          vim.fn.setreg("+", path)
          vim.notify("Copied: " .. path)
        end,
        ["gy"] = function(state)
          local node = state.tree:get_node()
          local path = vim.fn.fnamemodify(node:get_id(), ":.")
          vim.fn.setreg("+", path)
          vim.notify("Copied: " .. path)
        end,
      },
    },
  },
}
