require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
-- General Mappings
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
map("n", "<leader>y", '"+y')
map("n", "<leader>Y", '"+Y')
map("n", "<leader>d", '"_d')
map("n", "<leader>w", "<cmd> w <CR>", { desc = "Save file" })
map("n", "<C-S-A-j>", "<cmd> w <CR>", { desc = "Save file" })
map("n", "<leader>kj", function()
  local ft_cmds = {
    python = "python3 " .. vim.fn.expand "%",
  }
  require("nvchad.term").runner {
    pos = "sp",
    size = 0.3,
    cmd = ft_cmds[vim.bo.filetype],
    clear_cmd = false,
  }
end, { desc = "Execute current file" })
map("n", "<leader>x", "<cmd>!chmod +x %<CR>")
map("n", "<leader>q", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "Close buffer" })
--  format with conform
map("n", "<leader>fm", function()
  require("conform").format()
end, { desc = "formatting with conform" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected Up" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected Up" })
map("v", ">", ">gv", { desc = "indent" })
map("v", "<leader>d", '"_d')
map("v", "<leader>y", '"+y')
map("x", "<leader>p", '"_dP')
-- Obsidian
map("n", "<leader>jk", function()
  -- os.execute("cd /Users/aponce1509/OneDrive/Documents/2_areas/SecondBrain/00 - Map Of Contents/")
  local selected_files = require("bin.list-index").list_files()
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
end, { desc = "List all the Indexes" })
map(
  "n",
  "<leader>jd",
  "<cmd>vsplit ~/OneDrive/Documents/2_areas/SecondBrain/Todo.md<CR>:vertical resize 65%<CR>",
  { desc = "Open todo.md in a vertically split window" }
)
-- map("n", "<leader>jn","<cmd> ObsidianNew <CR>", {desc = "Obsidian New File)
map("n", "<leader>jn", "<cmd> ObsidianSearch <CR>", { desc = "Obsidian New File" })
map("n", "<leader>jo", "<cmd> ObsidianSearch <CR>", { desc = "Obsidian Search files" })
map(
  "n",
  "<leader>je",
  "<cmd> ObsidianOpen <CR>",
  { desc = "Obsidian Open External (obsidian App)" }
)
map(
  "n",
  "<leader>jb",
  "<cmd> ObsidianBacklinks <CR>",
  { desc = "Obsidian list backlinks" }
)
map("n", "<leader>jt", "<cmd> ObsidianTags <CR>", { desc = "Obsidian list all tags" })
map(
  "n",
  "<leader>jjn",
  "<cmd> ObsidianToday <CR>",
  { desc = "Obsidian open today note" }
)
map(
  "n",
  "<leader>jjy",
  "<cmd> ObsidianYesterday <CR>",
  { desc = "Obsidian open yesterday note" }
)
map(
  "n",
  "<leader>jjt",
  "<cmd> ObsidianTomorrow <CR>",
  { desc = "Obsidian open tomorow note" }
)
map(
  "n",
  "<leader>jjj",
  "<cmd> ObsidianDailies <CR>",
  { desc = "Obsidian open journal picker" }
)
map(
  "n",
  "<leader>jm",
  "<cmd> ObsidianTemplates <CR>",
  { desc = "Obsidian Insert Template" }
)
map(
  "n",
  "<leader>ji",
  "<cmd> ObsidianPasteImg <CR>",
  { desc = "Obsidian Paste Image from clipboard" }
)
map(
  "n",
  "<leader>jl",
  "<cmd> ObsidianLink <CR>",
  { desc = "Obsidian select Link and insert in cursor" }
)
map(
  "v",
  "<leader>jr",
  "<cmd> ObsidianExtractNote <CR>",
  { desc = "Obsidian extract selected to new note" }
)
map(
  "v",
  "<leader>jl",
  "<cmd> ObsidianLinkNew <CR>",
  { desc = "Obsidian Create new link from selected text" }
)
-- Telescope
map("n", "<leader>fg", "<cmd> Telescope git_files <CR>", { desc = "Find files" })
map("n", "<leader>fw", "<cmd> Telescope live_grep <CR>", { desc = "Live grep" })
map(
  "n",
  "<leader>ff",
  "<cmd> Telescope find_files find_command=rg,--no-ignore,--hidden,--glob=!**/.git/*"
    .. ",--glob=!**/.mypy_cache/*,--glob=!**/__pycache__/*,--files <CR>",
  { desc = "Find files" }
)

-- neotest
map("n", "<leader>kc", function()
  require("neotest").run.run()
end, { desc = "Test closest" })
map("n", "<leader>kf", function()
  require("neotest").run.run(vim.fn.expand "%")
end, { desc = "Test file" })
map("n", "<leader>kr", function()
  require("neotest").summary.toggle()
end, { desc = "Test output" })
map("n", "<leader>ko", function()
  require("neotest").output.open()
end, { desc = "Test output" })
map("n", "<leader>kd", function()
  require("neotest").run.run {
    strategy = "dap",
  }
end, { desc = "Test debug" })
map("n", "<leader>ks", function()
  require("neotest").run.stop()
end, { desc = "Test Stop" })
map("n", "<leader>ka", function()
  require("neotest").run.attach()
end, { desc = "Test attach" })
--   map("n", "<leader>td")
--   map("n", "<leader>to")
--   map("n", "<leader>tw")

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
-- undotree
map("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Toggle Undotree" })
-- gitlazy
map("n", "<leader>gl", "<cmd>LazyGit<CR>", { desc = "LazyGit status" })
-- fugitive
map("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Fugitive git status" })
-- harpoon
map("n", "<leader>a", function()
  local harpoon = require "harpoon"
  harpoon:list():add()
end, { desc = "Harpoon append" })
map("n", "<C-e>", function()
  local harpoon = require "harpoon"
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon quick Menu" })
map("n", "<C-S-E>", function()
  local harpoon = require "harpoon"
  local harpoon_utils = require "custom.configs.harpoon_utils"
  harpoon_utils.toggle_telescope(harpoon:list())
end, { desc = "Harpoon Telescope" })
-- map("n", "<C-j>", function()
--   local harpoon = require "harpoon"
--   harpoon:list():select(1)
-- end, { desc = "Harpoon go to 1" })
-- map("n", "<C-k>", function()
--   local harpoon = require "harpoon"
--   harpoon:list():select(2)
-- end, { desc = "Harpoon go to 2" })
-- map("n", "<C-l>", function()
--   local harpoon = require "harpoon"
--   harpoon:list():select(3)
-- end, { desc = "Harpoon go to 3" })
-- map("n", "<C-y>", function()
--   local harpoon = require "harpoon"
--   harpoon:list():select(4)
-- end, { desc = "Harpoon go to 4" })
-- more keybinds!
-- nvimtree
map("n", "<leader>e", "<cmd> NvimTreeToggle <CR>", { desc = "Toggle nvimtree" })
-- whichkey: TODO: change to noreamap
--   n = {
--     ["<leader>WK"] = {
--       function()
--         vim.cmd "WhichKey"
--       end,
--       "Which-key all keymaps",
--     },
--     ["<leader>Wk"] = {
--       function()
--         local input = vim.fn.input "WhichKey: "
--         vim.cmd("WhichKey " .. input)
--       end,
--       "Which-key query lookup",
--     },
--   },
-- }
-- dap
map("n", "<leader>ki", "<cmd> DapToggleBreakpoint <CR>")
-- dap_python
map("n", "<leader>kk", function()
  require("dap-python").test_method()
end, { desc = "Debug Current python file" })
-- lspconfig
-- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions
map("n", "<leader>.", function()
  -- vim.lsp.buf.code_action()
  require("actions-preview").code_actions()
end, { desc = "LSP code action" })
map("n", "<leader>Wa", function()
  vim.lsp.buf.add_workspace_folder()
end, { desc = "Add workspace folder" })

map("n", "<leader>Wr", function()
  vim.lsp.buf.remove_workspace_folder()
end, { desc = "Remove workspace folder" })

map("n", "<leader>Wl", function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = "List workspace folders" })

map("v", "<leader>.", function()
  vim.lsp.buf.code_action()
end, { desc = "LSP code action" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
-- ufo
map("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
map("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
map("n", "zK", function()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
end, { desc = "Peek Fold" })
