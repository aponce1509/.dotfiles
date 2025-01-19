local overrides = require "configs.overrides"

return {
  -- TODO: esta como extra
  {
    "pwntester/octo.nvim",
    lazy = "VeryLazy",
    cmd = { "Octo" },
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("octo").setup()
    end,
  },
  -- NOTE: They are using other thing
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      require("ufo").setup {
        provider_selector = function(bufnr, filetype, buftype)
          return { "lsp", "indent" }
        end,
      }
    end,
  },

  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here
    end,
  },
  {
    "stevearc/dressing.nvim",
    lazy = "VeryLazy",
    opts = {},
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  { "nvim-telescope/telescope-ui-select.nvim" },
  {
    "nvim-neotest/neotest",
    dependencies = { "antoinemadec/FixCursorHold.nvim", "nvim-neotest/neotest-python" },
    config = function()
      require "configs.neotest"
    end,
  }, -- nvim v0.8.0
  {
    "nvim-telescope/telescope.nvim",
    opts = overrides.telescope,
  },
  { -- Autocompletion
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  },
  {
    "aznhe21/actions-preview.nvim",
    -- config = function()
    --
    -- end,
  },
  -- using packer.nvim
  {
    "nmac427/guess-indent.nvim",
    lazy = false,
    cmd = { "GuessIndent" },
    config = function()
      require("guess-indent").setup {
        auto_cmd = true,               -- Set to false to disable automatic execution
        override_editorconfig = false, -- Set to true to override settings set by .editorconfig
        filetype_exclude = {           -- A list of filetypes for which the auto command gets disabled
          "netrw",
          "tutor",
        },
        buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
          "help",
          "nofile",
          "terminal",
          "prompt",
        },
      }
    end,
  },
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap-python",
    },
    opts = {
      -- Your options go here
      name = ".venv",
      anaconda_envs_path = "/Users/aponce1509/miniforge3/envs",
      -- auto_refresh = false
    },
    event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    keys = {            -- Keymap to open VenvSelector to pick a venv.
      { "<leader>vs", "<cmd>VenvSelect<cr>" },
      -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
      { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
    },
  },

  {
    "davidmh/cspell.nvim",
  },

}
