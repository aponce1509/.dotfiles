---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = {
      ":",
      "enter command mode",
      opts = {
        nowait = true,
      },
    },
    ["J"] = { "mzJ`z" },
    ["<C-d>"] = { "<C-d>zz" },
    ["<C-u>"] = { "<C-u>zz" },
    ["n"] = { "nzzzv" },
    ["N"] = { "Nzzzv" },
    ["<leader>s"] = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]] },
    ["<leader>y"] = { '"+y' },
    ["<leader>Y"] = { '"+Y' },
    ["<leader>d"] = { '"_d' },
    ["<leader>w"] = { "<cmd> w <CR>", "Save file " },
    ["<C-S-A-j>"] = { "<cmd> w <CR>", "Save file " },
    ["<leader>kj"] = {
      function()
        local ft_cmds = {
          python = "python3 " .. vim.fn.expand "%",
        }
        require("nvterm.terminal").send(ft_cmds[vim.bo.filetype])
      end,
      "Execute current file",
    },
    ["<leader>x"] = { "<cmd>!chmod +x %<CR>" },
    ["<leader>q"] = {
      function()
        require("nvchad.tabufline").close_buffer()
      end,
      "Close buffer",
    },
    --  format with conform
    ["<leader>fm"] = {
      function()
        require("conform").format()
      end,
      "formatting",
    },
  },
  v = {
    ["J"] = { ":m '>+1<CR>gv=gv", "Move selected Up" },
    ["K"] = { ":m '<-2<CR>gv=gv", "Move selected Up" },
    [">"] = { ">gv", "indent" },
    ["<leader>d"] = { '"_d' },
    ["<leader>y"] = { '"+y' },
  },
  x = {
    ["<leader>p"] = { '"_dP' },
  },
}

M.telescope = {
  plugin = true,

  n = {
    -- find
    ["<leader>fg"] = { "<cmd> Telescope git_files <CR>", "Find files" },
    ["<leader>fw"] = { "<cmd> Telescope live_grep <CR>", "Live grep" },
    ["<leader>ff"] = {
      "<cmd> Telescope find_files find_command=rg,--no-ignore,--hidden,--glob=!**/.git/*,--files <CR>",
      "Find files",
    },
  },
}

M.neotest = {
  -- plugin = true,
  n = {
    ["<leader>kc"] = {
      function()
        require("neotest").run.run()
      end,
      "Test closest",
    },
    ["<leader>kf"] = {
      function()
        require("neotest").run.run(vim.fn.expand "%")
      end,
      "Test file",
    },
    ["<leader>kr"] = {
      function()
        require("neotest").summary.toggle()
      end,
      "Test output",
    },
    ["<leader>ko"] = {
      function()
        require("neotest").output.open()
      end,
      "Test output",
    },
    ["<leader>kd"] = {
      function()
        require("neotest").run.run { strategy = "dap" }
      end,
      "Test debug",
    },
    ["<leader>ks"] = {
      function()
        require("neotest").run.stop()
      end,
      "Test Stop",
    },
    ["<leader>ka"] = {
      function()
        require("neotest").run.attach()
      end,
      "Test attach",
    },
    --   ["<leader>td"] = {},
    --   ["<leader>to"] = {},
    --   ["<leader>tw"] = {},
  },
}

M.undotree = {
  n = {
    ["<leader>u"] = { "<cmd>UndotreeToggle<CR>", "Toggle Undotree" },
  },
}
M.gitlazy = {
  n = {
    ["<leader>gl"] = { "<cmd>LazyGit<CR>", "LazyGit status" },
  },
}
M.fugitive = {
  n = {
    ["<leader>gs"] = { "<cmd>Git<CR>", "Fugitive git status" },
  },
}
M.harpoon = {
  n = {
    ["<leader>a"] = {
      function()
        local harpoon = require "harpoon"
        harpoon:list():append()
      end,
      "Harpoon append",
    },
    ["<C-e>"] = {
      function()
        local harpoon = require "harpoon"
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      "Harpoon quick Menu",
    },
    ["<C-S-E>"] = {
      function()
        local harpoon = require "harpoon"
        local harpoon_utils = require "custom.configs.harpoon_utils"
        harpoon_utils.toggle_telescope(harpoon:list())
      end,
      "Harpoon Telescope",
    },
    ["<C-j>"] = {
      function()
        local harpoon = require "harpoon"
        harpoon:list():select(1)
      end,
      "Harpoon go to 1",
    },
    ["<C-k>"] = {
      function()
        local harpoon = require "harpoon"
        harpoon:list():select(2)
      end,
      "Harpoon go to 2",
    },
    ["<C-l>"] = {
      function()
        local harpoon = require "harpoon"
        harpoon:list():select(3)
      end,
      "Harpoon go to 3",
    },
    ["<C-y>"] = {
      function()
        local harpoon = require "harpoon"
        harpoon:list():select(4)
      end,
      "Harpoon go to 4",
    },
  },
}
-- more keybinds!
M.nvimtree = {
  plugin = true,

  n = {
    -- toggle
    ["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },

    -- focus
  },
}

M.whichkey = {
  plugin = true,

  n = {
    ["<leader>WK"] = {
      function()
        vim.cmd "WhichKey"
      end,
      "Which-key all keymaps",
    },
    ["<leader>Wk"] = {
      function()
        local input = vim.fn.input "WhichKey: "
        vim.cmd("WhichKey " .. input)
      end,
      "Which-key query lookup",
    },
  },
}
M.dap = {
  plugin = true,
  n = {
    ["<leader>ki"] = { "<cmd> DapToggleBreakpoint <CR>" },
  },
}

M.dap_python = {
  plugin = true,
  n = {
    ["<leader>kk"] = {
      function()
        require("dap-python").test_method()
      end,
      "Debug Current python file",
    },
  },
}
M.lspconfig = {
  plugin = true,

  -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions

  n = {
    ["<leader>Wa"] = {
      function()
        vim.lsp.buf.add_workspace_folder()
      end,
      "Add workspace folder",
    },

    ["<leader>Wr"] = {
      function()
        vim.lsp.buf.remove_workspace_folder()
      end,
      "Remove workspace folder",
    },

    ["<leader>Wl"] = {
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      "List workspace folders",
    },
  },
}

return M
