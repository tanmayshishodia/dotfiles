-- Comprehensive Python setup for LazyVim
return {
  -- ===========================================
  -- LazyVim Python Extras (core functionality)
  -- ===========================================
  { import = "lazyvim.plugins.extras.lang.python" },

  -- ===========================================
  -- LSP Configuration
  -- ===========================================
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Pyright disabled — ty is the type checker
        pyright = { enabled = false },

        -- ty: Astral's type checker (replaces pyright)
        ty = {
          cmd = { "ty", "server" },
          filetypes = { "python" },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "pyproject.toml",
              "setup.py",
              "setup.cfg",
              "requirements.txt",
              ".git"
            )(fname) or vim.fn.getcwd()
          end,
        },

        -- Ruff LSP for fast linting
        ruff = {
          cmd_env = { RUFF_TRACE = "messages" },
          init_options = {
            settings = {
              logLevel = "error",
            },
          },
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = { only = { "source.organizeImports" }, diagnostics = {} },
                })
              end,
              desc = "Organize Imports",
            },
          },
        },
      },
    },
  },

  -- ===========================================
  -- Mason - Install Python tools
  -- ===========================================
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "ruff",
        "debugpy",
        "mypy",
        "black",
        "isort",
      },
    },
  },

  -- ===========================================
  -- Formatting with conform.nvim
  -- ===========================================
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = {
          "ruff_organize_imports",
          "ruff_format",
        },
      },
    },
  },

  -- ===========================================
  -- Virtual Environment Selector
  -- ===========================================
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap-python",
    },
    cmd = "VenvSelect",
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
      { "<leader>cV", "<cmd>VenvSelectCached<cr>", desc = "Select Cached VirtualEnv" },
    },
    opts = {
      settings = {
        search = {
          virtualenvs = {
            command = "fd 'python$' ~/.virtualenvs --type x --full-path",
          },
          conda = {
            command = "fd 'python$' ~/anaconda3/envs ~/miniconda3/envs --type x --full-path",
          },
          venv = {
            command = "fd 'python$' . --type x --full-path -E .git -E node_modules -E __pycache__ -d 4",
          },
          poetry = {
            command = "fd 'python$' ~/.cache/pypoetry/virtualenvs --type x --full-path",
          },
        },
      },
    },
  },

  -- ===========================================
  -- Testing with neotest
  -- ===========================================
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          runner = "pytest",
          python = function()
            -- Try to get python from venv-selector first
            local venv = require("venv-selector").python()
            if venv then
              return venv
            end
            -- Fallback to system python
            return "python"
          end,
          args = { "--tb=short", "-v" },
          dap = { justMyCode = false },
        },
      },
    },
    keys = {
      { "<leader>tp", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop Tests" },
    },
  },

  -- ===========================================
  -- Debugging with DAP
  -- ===========================================
  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "mason-org/mason.nvim",
    },
    keys = {
      { "<leader>dPt", function() require("dap-python").test_method() end, desc = "Debug Test Method" },
      { "<leader>dPc", function() require("dap-python").test_class() end, desc = "Debug Test Class" },
      { "<leader>dPs", function() require("dap-python").debug_selection() end, mode = "v", desc = "Debug Selection" },
    },
    config = function()
      -- Try to find debugpy in mason's install location
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      if vim.fn.executable(mason_path) == 1 then
        require("dap-python").setup(mason_path)
      else
        -- Fallback to system python
        require("dap-python").setup("python")
      end
    end,
  },

  -- ===========================================
  -- Docstring Generation
  -- ===========================================
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    cmd = "Neogen",
    keys = {
      { "<leader>cg", "<cmd>Neogen func<cr>", desc = "Generate Function Docstring" },
      { "<leader>cG", "<cmd>Neogen class<cr>", desc = "Generate Class Docstring" },
    },
    opts = {
      snippet_engine = "luasnip",
      languages = {
        python = {
          template = {
            annotation_convention = "google_docstrings", -- or "numpydoc", "sphinx"
          },
        },
      },
    },
  },

  -- ===========================================
  -- Better Treesitter for Python
  -- ===========================================
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "python",
        "rst",
        "toml",
        "ninja",
      },
    },
  },

  -- ===========================================
  -- Jupyter Notebook Support (optional)
  -- ===========================================
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    opts = {
      style = "markdown",
      output_extension = "md",
      force_ft = "markdown",
    },
  },

  -- ===========================================
  -- Auto-activate virtual environments
  -- ===========================================
  {
    "AckslD/swenv.nvim",
    enabled = false, -- Enable if you prefer this over venv-selector
    opts = {
      get_venvs = function(venvs_path)
        return require("swenv.api").get_venvs(venvs_path)
      end,
      venvs_path = vim.fn.expand("~/.virtualenvs"),
      post_set_venv = function()
        vim.cmd("LspRestart")
      end,
    },
  },

  -- ===========================================
  -- Inlay Hints (built into Neovim 0.10+)
  -- ===========================================
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = true,
      },
    },
  },

  -- ===========================================
  -- Show venv in statusline (lualine)
  -- ===========================================
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          local venv = require("venv-selector").venv()
          if venv then
            -- Show just the venv name, not full path
            return "  " .. vim.fn.fnamemodify(venv, ":t")
          end
          return ""
        end,
        cond = function()
          return vim.bo.filetype == "python"
        end,
        color = { fg = "#CBA6F7" },
      })
    end,
  },
}
