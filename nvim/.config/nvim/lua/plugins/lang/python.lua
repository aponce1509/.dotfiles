return {
  -- Additional Plug-ins
  -- LazyVim Plug-ins
  { "linux-cultist/venv-selector.nvim", enabled = false },
  -- Mason dependencies
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "black", "mypy"
      })
    end,
  },
  -- treesitter dependencies
  -- Linting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "mypy" },
      },
      linters = {
        mypy = {
          -- TODO: ARGS do not work, so you are force to mypy.ini / pyproject.toml file
          -- This works because of the autoselection of venv
          -- Looks that mypy installed by mason can use the env packages though
          cmd = "mypy",
          -- args = { "--strict" }
          -- args = function()
          --   local virtual = os.getenv "CONDA_PREFIX" or os.getenv "VIRTUAL_ENV" or "/usr"
          --   return { "--stricta", "--python-executable", virtual .. "/bin/python" }
          -- end,

        }
      }
    }
  },
  -- Formatting
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = { python = { "black" } }
    end,
  },
}
