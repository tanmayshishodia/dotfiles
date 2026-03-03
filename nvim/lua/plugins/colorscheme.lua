-- Dark High Contrast theme to match Cursor's "Default High Contrast"
return {
  -- Add tokyonight as base (has good high contrast variant)
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
        sidebars = "dark",
        floats = "dark",
      },
      on_colors = function(colors)
        -- Pitch black backgrounds
        colors.bg = "#000000"
        colors.bg_dark = "#000000"
        colors.bg_float = "#000000"
        colors.bg_popup = "#000000"
        colors.bg_sidebar = "#000000"
        colors.bg_statusline = "#0a0a0a"
        colors.bg_highlight = "#1a1a1a"

        -- High contrast foreground
        colors.fg = "#ffffff"
        colors.fg_dark = "#e0e0e0"
        colors.fg_gutter = "#555555"

        -- Vibrant syntax colors (matching VS Code High Contrast)
        colors.blue = "#569cd6"
        colors.cyan = "#4ec9b0"
        colors.blue1 = "#9cdcfe"
        colors.blue2 = "#4fc1ff"
        colors.magenta = "#c586c0"
        colors.purple = "#b4a7d6"
        colors.orange = "#ce9178"
        colors.yellow = "#dcdcaa"
        colors.green = "#6a9955"
        colors.green1 = "#4ec9b0"
        colors.red = "#f44747"
        colors.red1 = "#d16969"
      end,
      on_highlights = function(hl, c)
        -- Editor UI - high contrast borders and selections
        hl.CursorLine = { bg = "#1a1a1a" }
        hl.CursorLineNr = { fg = "#ffffff", bold = true }
        hl.LineNr = { fg = "#858585" }
        hl.Visual = { bg = "#264f78" }
        hl.VisualNOS = { bg = "#264f78" }
        hl.Search = { bg = "#613214", fg = "#ffffff" }
        hl.IncSearch = { bg = "#ffcc00", fg = "#000000" }

        -- Borders and separators
        hl.VertSplit = { fg = "#6b6b6b" }
        hl.WinSeparator = { fg = "#6b6b6b" }
        hl.FloatBorder = { fg = "#6b6b6b", bg = "#000000" }

        -- Popup menus
        hl.Pmenu = { bg = "#1e1e1e", fg = "#ffffff" }
        hl.PmenuSel = { bg = "#094771", fg = "#ffffff" }
        hl.PmenuSbar = { bg = "#1e1e1e" }
        hl.PmenuThumb = { bg = "#474747" }

        -- Syntax - bright and clear (matching Cursor High Contrast)
        hl.Comment = { fg = "#6a9955" }
        hl.Keyword = { fg = "#569cd6" }
        hl.Function = { fg = "#dcdcaa" }
        hl.String = { fg = "#ce9178" }
        hl.Number = { fg = "#b5cea8" }
        hl.Boolean = { fg = "#569cd6" }
        hl.Type = { fg = "#4ec9b0" }
        hl.Constant = { fg = "#4fc1ff" }
        hl.Operator = { fg = "#d4d4d4" }
        hl.Identifier = { fg = "#9cdcfe" }
        hl.Statement = { fg = "#569cd6" }
        hl.PreProc = { fg = "#569cd6" }
        hl.Special = { fg = "#d7ba7d" }

        -- Treesitter specific (Python-focused matching Cursor)
        hl["@keyword"] = { fg = "#569cd6" }
        hl["@keyword.function"] = { fg = "#569cd6" }
        hl["@keyword.return"] = { fg = "#569cd6" }
        hl["@keyword.operator"] = { fg = "#569cd6" }
        hl["@keyword.import"] = { fg = "#569cd6" }
        hl["@conditional"] = { fg = "#569cd6" }
        hl["@repeat"] = { fg = "#569cd6" }
        hl["@exception"] = { fg = "#569cd6" }
        hl["@include"] = { fg = "#569cd6" }

        -- Functions - yellow
        hl["@function"] = { fg = "#dcdcaa" }
        hl["@function.call"] = { fg = "#dcdcaa" }
        hl["@function.builtin"] = { fg = "#dcdcaa" }
        hl["@method"] = { fg = "#dcdcaa" }
        hl["@method.call"] = { fg = "#dcdcaa" }

        -- Decorators - yellow/gold
        hl["@attribute"] = { fg = "#dcdcaa" }
        hl["@attribute.builtin"] = { fg = "#dcdcaa" }
        hl["@decorator"] = { fg = "#dcdcaa" }

        -- Classes - green/teal
        hl["@type"] = { fg = "#4ec9b0" }
        hl["@type.builtin"] = { fg = "#4ec9b0" }
        hl["@type.definition"] = { fg = "#4ec9b0" }
        hl["@class"] = { fg = "#4ec9b0" }
        hl["@constructor"] = { fg = "#4ec9b0" }

        -- Variables
        hl["@variable"] = { fg = "#9cdcfe" }
        hl["@variable.builtin"] = { fg = "#569cd6" }
        hl["@variable.parameter"] = { fg = "#9cdcfe" }
        hl["@variable.member"] = { fg = "#9cdcfe" }

        -- self/cls - red/magenta (Python specific)
        hl["@variable.parameter.builtin"] = { fg = "#569cd6" }

        -- Properties and fields
        hl["@property"] = { fg = "#9cdcfe" }
        hl["@field"] = { fg = "#9cdcfe" }
        hl["@parameter"] = { fg = "#9cdcfe" }

        -- Strings
        hl["@string"] = { fg = "#ce9178" }
        hl["@string.documentation"] = { fg = "#ce9178" }
        hl["@string.escape"] = { fg = "#d7ba7d" }
        hl["@string.special"] = { fg = "#d7ba7d" }

        -- Numbers and booleans
        hl["@number"] = { fg = "#b5cea8" }
        hl["@number.float"] = { fg = "#b5cea8" }
        hl["@boolean"] = { fg = "#569cd6" }

        -- Constants
        hl["@constant"] = { fg = "#4fc1ff" }
        hl["@constant.builtin"] = { fg = "#569cd6" }

        -- Namespace/module
        hl["@namespace"] = { fg = "#4ec9b0" }
        hl["@module"] = { fg = "#4ec9b0" }

        -- Punctuation and operators
        hl["@punctuation"] = { fg = "#d4d4d4" }
        hl["@punctuation.bracket"] = { fg = "#d4d4d4" }
        hl["@punctuation.delimiter"] = { fg = "#d4d4d4" }
        hl["@punctuation.special"] = { fg = "#569cd6" }
        hl["@operator"] = { fg = "#d4d4d4" }

        -- Comments
        hl["@comment"] = { fg = "#6a9955" }
        hl["@comment.documentation"] = { fg = "#6a9955" }

        -- Tags (HTML/XML)
        hl["@tag"] = { fg = "#569cd6" }
        hl["@tag.attribute"] = { fg = "#9cdcfe" }
        hl["@tag.delimiter"] = { fg = "#808080" }

        -- Diagnostics - bright and visible
        hl.DiagnosticError = { fg = "#f44747" }
        hl.DiagnosticWarn = { fg = "#ff8800" }
        hl.DiagnosticInfo = { fg = "#4fc1ff" }
        hl.DiagnosticHint = { fg = "#6a9955" }

        -- Git signs
        hl.GitSignsAdd = { fg = "#6a9955" }
        hl.GitSignsChange = { fg = "#0078d4" }
        hl.GitSignsDelete = { fg = "#f44747" }

        -- Telescope
        hl.TelescopeBorder = { fg = "#6b6b6b", bg = "#000000" }
        hl.TelescopeNormal = { bg = "#000000" }
        hl.TelescopePromptBorder = { fg = "#6b6b6b", bg = "#000000" }
        hl.TelescopeResultsBorder = { fg = "#6b6b6b", bg = "#000000" }
        hl.TelescopePreviewBorder = { fg = "#6b6b6b", bg = "#000000" }

        -- Neo-tree
        hl.NeoTreeNormal = { bg = "#000000" }
        hl.NeoTreeNormalNC = { bg = "#000000" }
        hl.NeoTreeEndOfBuffer = { bg = "#000000" }

        -- Which-key
        hl.WhichKeyFloat = { bg = "#000000" }

        -- Indent guides
        hl.IblIndent = { fg = "#333333" }
        hl.IblScope = { fg = "#555555" }

        -- LSP Semantic Tokens (for better Python highlighting)
        hl["@lsp.type.class"] = { fg = "#4ec9b0" }
        hl["@lsp.type.decorator"] = { fg = "#dcdcaa" }
        hl["@lsp.type.function"] = { fg = "#dcdcaa" }
        hl["@lsp.type.method"] = { fg = "#dcdcaa" }
        hl["@lsp.type.parameter"] = { fg = "#9cdcfe" }
        hl["@lsp.type.property"] = { fg = "#9cdcfe" }
        hl["@lsp.type.variable"] = { fg = "#9cdcfe" }
        hl["@lsp.type.namespace"] = { fg = "#4ec9b0" }
        hl["@lsp.type.type"] = { fg = "#4ec9b0" }
        hl["@lsp.type.typeParameter"] = { fg = "#4ec9b0" }
        hl["@lsp.type.enum"] = { fg = "#4ec9b0" }
        hl["@lsp.type.enumMember"] = { fg = "#4fc1ff" }
        hl["@lsp.type.interface"] = { fg = "#4ec9b0" }
        hl["@lsp.type.struct"] = { fg = "#4ec9b0" }
        hl["@lsp.type.keyword"] = { fg = "#569cd6" }
        hl["@lsp.type.comment"] = { fg = "#6a9955" }
        hl["@lsp.type.string"] = { fg = "#ce9178" }
        hl["@lsp.type.number"] = { fg = "#b5cea8" }

        -- Python-specific semantic tokens
        hl["@lsp.typemod.variable.defaultLibrary"] = { fg = "#4ec9b0" }
        hl["@lsp.typemod.function.defaultLibrary"] = { fg = "#dcdcaa" }
        hl["@lsp.typemod.method.defaultLibrary"] = { fg = "#dcdcaa" }
        hl["@lsp.typemod.class.defaultLibrary"] = { fg = "#4ec9b0" }
        hl["@lsp.mod.declaration"] = {}
        hl["@lsp.mod.definition"] = {}

        -- self parameter in Python - blue like keywords
        hl["@lsp.typemod.parameter.definition.python"] = { fg = "#9cdcfe" }
        hl["@lsp.type.selfParameter"] = { fg = "#569cd6" }
        hl["@lsp.type.selfKeyword"] = { fg = "#569cd6" }
      end,
    },
  },

  -- Configure LazyVim to use the theme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
