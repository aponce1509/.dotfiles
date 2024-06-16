local overrides = require "configs.overrides"

return {

  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },
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
  {"petertriho/cmp-git", requires = "nvim-lua/plenary.nvim"},
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    config = function()
      require "configs.neotree"
    end,
  },
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
    "MysticalDevil/inlay-hints.nvim",
    event = "LspAttach",
    cmd = { "InlayHintsToggle" },
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("inlay-hints").setup { autocmd = { enable = true } }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    -- opts = {
    --   inlay_hints = { enabled = true },
    -- },
    config = function()
      require "nvchad.configs.lspconfig"
      require "configs.lspconfig"
    end, -- Override to setup mason-lspconfig
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
    dependencies = { "antoinemadec/FixCursorHold.nvim" },
    config = function()
      require "configs.neotest"
    end,
  }, -- nvim v0.8.0
  {
    "tpope/vim-fugitive",
    cmd = { "Git" },
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "mbbill/undotree",
    lazy = false,
  }, -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },
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
        auto_cmd = true, -- Set to false to disable automatic execution
        override_editorconfig = false, -- Set to true to override settings set by .editorconfig
        filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
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
    "epwalsh/obsidian.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    lazy = false,
    version = "*",
    config = function()
      require "configs.obsidian"
    end,
    cmd = {
      "ObsidianOpen",
      "ObsidianNew",
      "ObsidianQuickSwitch",
      "ObsidianFollowLink",
      "ObsidianBacklinks",
      "ObsidianTags",
      "ObsidianToday",
      "ObsidianYesterday",
      "ObsidianTomorrow",
      "ObsidianDailies",
      "ObsidianTemplate",
      "ObsidianSearch",
      "ObsidianLink",
      "ObsidianLinkNew",
      "ObsidianLinks",
      "ObsidianExtractNote",
      "ObsidianWorkspace",
      "ObsidianPasteImg",
      "ObsidianRename",
    },
  },
  -- {
  --   "Olical/conjure",
  --   ft = { "clojure", "fennel", "python" }, -- etc
  --   -- [Optional] cmp-conjure for cmp
  --   cmd = {
  --     "ConjureSchool",
  --     "ConjureEval",
  --   },
  --   dependencies = {
  --     {
  --       "PaterJason/cmp-conjure",
  --       config = function()
  --         local cmp = require "cmp"
  --         local config = cmp.get_config()
  --         table.insert(config.sources, {
  --           name = "buffer",
  --           option = {
  --             sources = {
  --               { name = "conjure" },
  --             },
  --           },
  --         })
  --         cmp.setup(config)
  --       end,
  --     },
  --   },
  --   config = function(_, opts)
  --     require("conjure.main").main()
  --     require("conjure.mapping")["on-filetype"]()
  --   end,
  --   init = function()
  --     -- Set configuration options here
  --     vim.g["conjure#debug"] = true
  --   end,
  -- },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  }, -- Install a plugin
  {
    "rmagatti/auto-session",
    cmd = { "AutoSessionRestore", "AutoSessionDelete" },
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      }
    end,
  },
  -- Lua
  -- {
  --   "folke/persistence.nvim",
  --   event = "BufReadPre", -- this will only start session saving when an actual file was opened
  --   opts = {
  --     -- add any custom options here
  --   },
  -- },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require("dashboard").setup {
        -- config
      }
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  {
    "mfussenegger/nvim-dap",
    -- config = function(_, opts)
    --   require("core.utils").load_mappings "dap"
    -- end,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" },
    config = function(_, opts)
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
      -- require("core.utils").load_mappings "dap_python"
    end,
  },
  {
    "stevearc/conform.nvim",
    --  for users those who want auto-save conform + lazyloading!
    -- event = "BufWritePre"
    config = function()
      require "configs.conform"
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
    keys = { -- Keymap to open VenvSelector to pick a venv.
      { "<leader>vs", "<cmd>VenvSelect<cr>" },
      -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
      { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
    },
  },
  {
    "rebelot/heirline.nvim",
    -- You can optionally lazy-load heirline on UiEnter
    -- to make sure all required plugins and colorschemes are loaded before setup
    -- event = "UiEnter",
    config = function()
      require("heirline").setup()
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    lazy = false,
    config = function()
      require "configs.null-ls"
    end,
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
      "gbprod/none-ls-shellcheck.nvim",
    },
    -- ft = { "python" }
    -- opts = function()
    --   return require "configs.null-ls"
    -- end,
  },
  {
    "davidmh/cspell.nvim",
  },
  {
    "rmagatti/auto-session",
    lazy = false,
  },
  {
    "ThePrimeagen/harpoon",
    lazy = false,
  },

  -- These are some examples, uncomment them if you want to see them work!
  -- {
  --   "neovim/nvim-lspconfig",
  --   config = function()
  --     require("nvchad.configs.lspconfig").defaults()
  --     require "configs.lspconfig"
  --   end,
  -- },
  --
  -- {
  -- 	"williamboman/mason.nvim",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"lua-language-server", "stylua",
  -- 			"html-lsp", "css-lsp" , "prettier"
  -- 		},
  -- 	},
  -- },
  --
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
