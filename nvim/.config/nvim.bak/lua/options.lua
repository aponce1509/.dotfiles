require "nvchad.options"

-- add yours here!

local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
-- local autocmd = vim.api.nvim_create_autocmd
local opt = vim.opt
local g = vim.g

opt.relativenumber = true
-- vim.o.spelllang = "en,es"
-- vim.o.spell = true
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

opt.smartindent = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.clipboard = ""

vim.o.conceallevel = 0

local virtual = os.getenv "CONDA_PREFIX" or os.getenv "VIRTUAL_ENV" or "/usr"
vim.g.loaded_python3_provider = 1
vim.g.python3_host_prog = virtual .. '/bin/python3'

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv "HOME" .. "/.vim/undodir"
opt.undofile = true

opt.scrolloff = 8
opt.isfname:append "@-@"
opt.updatetime = 50
opt.colorcolumn = "88"

vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Auto select virtualenv Nvim open",
  pattern = "*",
  callback = function()
    local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
    if venv ~= "" then
      require("venv-selector").retrieve_from_cache()
    end
  end,
  once = true,
})

-- g.colorcolum = 80
-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

-- local actived_venv = function()
--   local venv_name = require('venv-selector').get_active_venv()
--   if venv_name ~= nil then
--     return string.gsub(venv_name, '.*/pypoetry/virtualenvs/', '(poetry) ')
--   else
--     return 'venv'
--   end
-- end
--
-- local venv = {
--   {
--     provider = function()
--       return '  ' .. actived_venv()
--     end,
--   },
--   on_click = {
--     callback = function()
--       vim.cmd.VenvSelect()
--     end,
--     name = 'heirline_statusline_venv_selector',
--   },
-- }
