-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
-- local o = vim.o
-- local g = vim.g
-- o.cursorlineopt ='both' -- to enable cursorline!
-- local autocmd = vim.api.nvim_create_autocmd

opt.relativenumber = true
-- vim.o.spelllang = "en,es"
-- vim.o.spell = true
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
-- vim.o.completeopt = "menuone,noselect,preview"
vim.opt.splitkeep = "screen"
vim.opt.laststatus = 3

-- opt.smartindent = true
-- opt.tabstop = 4
-- opt.softtabstop = 4
-- opt.shiftwidth = 4
-- opt.expandtab = true
opt.clipboard = ""
opt.spelllang = { "en", "es" }

-- vim.o.conceallevel = 0

local virtual = os.getenv("CONDA_PREFIX") or os.getenv("VIRTUAL_ENV") or "/usr"
vim.g.loaded_python3_provider = 1
vim.g.python3_host_prog = virtual .. "/bin/python3"
-- vim.g.lazyvim_python_lsp = "pylyzer"

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.scrolloff = 8
opt.isfname:append("@-@")
opt.updatetime = 50
opt.colorcolumn = "88"

vim.g.lazyvim_blink_main = false
vim.g.lazyvim_cmp = "nvim-cmp"

-- vim.api.nvim_create_autocmd("VimEnter", {
--   desc = "Auto select virtualenv Nvim open",
--   pattern = "*",
--   callback = function()
--     local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
--     if venv ~= "" then
--       require("venv-selector").retrieve_from_cache()
--     end
--   end,
--   once = true,
-- })
