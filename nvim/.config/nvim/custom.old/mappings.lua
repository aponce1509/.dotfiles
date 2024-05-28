---@type MappingsTable
local M = {}

M.general = {
  n = {
    -- [";"] = {
    --   ":",
    --   "enter command mode",
    --   opts = {
    --     nowait = true,
    --   },
    -- },
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
M.bins = {
  n = {
    ["<leader>jk"] = {
      function()
        -- os.execute("cd /Users/aponce1509/OneDrive/Documents/2_areas/SecondBrain/00 - Map Of Contents/")
        local selected_files = require("custom.bin.list-index").list_files()
        -- Create a mapping between basenames and full paths
        local basename_to_path = {}
        for _, file in ipairs(selected_files) do
          local basename = vim.fn.fnamemodify(file, ":t")
          basename_to_path[basename] = file
        end
        local basenames = vim.tbl_keys(basename_to_path)
        print(basenames)
        local conf = require("telescope.config").values
        require("telescope.pickers")
          .new({}, {
            prompt_title = "Map Of Content",
            finder = require("telescope.finders").new_table {
              results = basenames,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
            attach_mappings = function(prompt_bufnr)
              require("telescope.actions.set").select:replace(function(_, type)
                local entry = require("telescope.actions.state").get_selected_entry()
                local basename = entry.value
                local full_path = basename_to_path[basename]
                if full_path then
                  require("telescope.actions").close(prompt_bufnr)
                  vim.cmd("edit " .. vim.fn.fnameescape(full_path))
                end
              end)
              return true
            end,
          })
          :find()
      end,
    },
  },
}
M.obsidian = {
  n = {
    ["<leader>jd"] = {
      "<cmd>vsplit ~/OneDrive/Documents/2_areas/SecondBrain/Todo.md<CR>:vertical resize 65%<CR>",
      "Open todo.md in a vertically split window",
    }, -- ["<leader>jn"] = {"<cmd> ObsidianNew <CR>", "Obsidian New File"},
    ["<leader>jn"] = { "<cmd> ObsidianSearch <CR>", "Obsidian New File" },
    ["<leader>jo"] = { "<cmd> ObsidianSearch <CR>", "Obsidian Search files" },
    ["<leader>je"] = {
      "<cmd> ObsidianOpen <CR>",
      "Obsidian Open External (obsidian App)",
    },
    ["<leader>jb"] = { "<cmd> ObsidianBacklinks <CR>", "Obsidian list backlinks" },
    ["<leader>jt"] = { "<cmd> ObsidianTags <CR>", "Obsidian list all tags" },
    ["<leader>jjn"] = { "<cmd> ObsidianToday <CR>", "Obsidian open today note" },
    ["<leader>jjy"] = { "<cmd> ObsidianYesterday <CR>", "Obsidian open yesterday note" },
    ["<leader>jjt"] = { "<cmd> ObsidianTomorrow <CR>", "Obsidian open tomorow note" },
    ["<leader>jjj"] = { "<cmd> ObsidianDailies <CR>", "Obsidian open journal picker" },
    ["<leader>jm"] = { "<cmd> ObsidianTemplates <CR>", "Obsidian Insert Template" },
    ["<leader>ji"] = {
      "<cmd> ObsidianPasteImg <CR>",
      "Obsidian Paste Image from clipboard",
    },
    ["<leader>jl"] = {
      "<cmd> ObsidianLink <CR>",
      "Obsidian select Link and insert in cursor",
    },
  },
  v = {
    ["<leader>jr"] = {
      "<cmd> ObsidianExtractNote <CR>",
      "Obsidian extract selected to new note",
    },
    ["<leader>jl"] = {
      "<cmd> ObsidianLinkNew <CR>",
      "Obsidian Create new link from selected text",
    },
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
        require("neotest").run.run {
          strategy = "dap",
        }
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
-- M.sessions = {
--   n = {
--     ["<leader>ic"] = {
--       function()
--         require("persistence").load()
--       end,
--       "Load current session for directory",
--     },
--     ["<leader>il"] = {
--       function()
--         require("persistence").load { last = true }
--       end,
--       "Load last session",
--     },
--     ["<leader>is"] = {
--       function()
--         require("persistence").stop()
--       end,
--       "Stop Saving session",
--     },
--   },
-- }
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
    ["<leader>."] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "LSP code action",
    },
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
  v = {
    ["<leader>."] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "LSP code action",
    },
  },
}

return M
