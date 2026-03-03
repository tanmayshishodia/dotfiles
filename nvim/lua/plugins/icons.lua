-- Enhanced icons and symbol outline
return {
  -- Better devicons with more file types
  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      color_icons = true,
      default = true,
      strict = true,
    },
  },

  -- Symbol outline (treesitter-based code structure)
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>cs", "<cmd>Outline<cr>", desc = "Toggle Symbol Outline" },
      { "<leader>cS", "<cmd>OutlineFocus<cr>", desc = "Focus Symbol Outline" },
    },
    opts = {
      outline_window = {
        position = "right",
        width = 30,
        relative_width = false,
      },
      symbols = {
        -- Use nerd font icons
        icons = {
          File = { icon = "", hl = "Identifier" },
          Module = { icon = "", hl = "Include" },
          Namespace = { icon = "", hl = "Include" },
          Package = { icon = "", hl = "Include" },
          Class = { icon = "", hl = "Type" },
          Method = { icon = "", hl = "Function" },
          Property = { icon = "", hl = "Identifier" },
          Field = { icon = "", hl = "Identifier" },
          Constructor = { icon = "", hl = "Special" },
          Enum = { icon = "", hl = "Type" },
          Interface = { icon = "", hl = "Type" },
          Function = { icon = "󰊕", hl = "Function" },
          Variable = { icon = "", hl = "Constant" },
          Constant = { icon = "", hl = "Constant" },
          String = { icon = "", hl = "String" },
          Number = { icon = "#", hl = "Number" },
          Boolean = { icon = "", hl = "Boolean" },
          Array = { icon = "", hl = "Constant" },
          Object = { icon = "", hl = "Type" },
          Key = { icon = "", hl = "Type" },
          Null = { icon = "󰟢", hl = "Type" },
          EnumMember = { icon = "", hl = "Identifier" },
          Struct = { icon = "", hl = "Structure" },
          Event = { icon = "", hl = "Type" },
          Operator = { icon = "", hl = "Identifier" },
          TypeParameter = { icon = "", hl = "Identifier" },
        },
      },
    },
  },
}
