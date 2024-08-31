-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local del = vim.keymap.del
local LazyVim = require("lazyvim.util")

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jj", "<ESC>")
map("n", "<leader>/", "gcc", { desc = "comment toggle", remap = true })
map("v", "<leader>/", "gc", { desc = "comment toggle", remap = true })
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
map("n", "<leader>x", "<cmd>!chmod +x %<CR>")
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected Up" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected Up" })
map("v", ">", ">gv", { desc = "indent" })
map("v", "<leader>d", '"_d')
map("v", "<leader>y", '"+y')
map("x", "<leader>p", '"_dP')
-- panes
-- quit
map("n", "<localleader>q", "<leader>wq", { remap = true, desc = "Quit windows" })
map("n", "<localleader>Q", "<leader>wo", { remap = true, desc = "Quit all other windows" })
-- movement
map("n", '<c-h>', ':wincmd h<CR>', { remap = true, desc = "Go to left window", silent = true })
map("n", '<c-j>', ':wincmd j<CR>', { remap = true, desc = "Go to down window", silent = true })
map("n", '<c-k>', ':wincmd k<CR>', { remap = true, desc = "Go to top window", silent = true })
map("n", '<c-l>', ':wincmd l<CR>', { remap = true, desc = "Go to right window", silent = true })
--
map("n", "<localleader>h", "<C-w>h", { remap = true, desc = "Go to left window" })
map("n", "<localleader>j", "<C-w>j", { remap = true, desc = "Go to down window" })
map("n", "<localleader>k", "<C-w>k", { remap = true, desc = "Go to top window" })
map("n", "<localleader>l", "<C-w>l", { remap = true, desc = "Go to right window" })
-- resize
map("n", "<localleader>A", "<C-w><", { remap = true, desc = "Decrease width" })
map("n", "<localleader>D", "<C-w>>", { remap = true, desc = "Increase width" })
map("n", "<localleader>W", "<C-w>+", { remap = true, desc = "Increase height" })
map("n", "<localleader>S", "<C-w>-", { remap = true, desc = "Decrease height" })
map("n", "<localleader>=", "<C-w>-", { remap = true, desc = "Equally high and wide" })
-- split
map("n", "<localleader>s", "<C-w>s", { remap = true, desc = "Vertical Split" })
map("n", "<localleader>v", "<C-w>v", { remap = true, desc = "Horizontal Split" })
-- fullscreen
map("n", "<localleader>m", "<C-w>m", { remap = true, desc = "Enable Maximize" })

map("n", "<localleader>h", "<C-w>h", { remap = true, desc = "" })
-- terminal
-- just Delete default integration

del("n", "<leader>ft")
del("n", "<leader>fT")
del("n", "<c-/>")
del("n", "<c-_>")

-- Terminal Mappings
function _runner_toggle()
  local Terminal = require("toggleterm.terminal").Terminal
  local ft_cmds = {
    python = "python " .. '' .. vim.fn.expand("%"),
  }
  -- print(ft_cmds[vim.bo.filetype])
  local runner = Terminal:new({
    id = 0,
    cmd = ft_cmds[vim.bo.filetype],
    direction = "horizontal",
    display_name = "runner",
    close_on_exit = false,
    hidden = false,
  })
  runner:toggle()
end

map("n", "<leader>kj", "<cmd>lua _runner_toggle()<CR>", { noremap = true, silent = true })
del("t", "<esc><esc>")
del("t", "<C-h>")
del("t", "<C-j>")
del("t", "<C-k>")
del("t", "<C-l>")
del("t", "<C-/>")
del("t", "<c-_>")

-- buffers
del("n", "<S-h>")
del("n", "<S-l>")

map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<leader>q", LazyVim.ui.bufremove, { desc = "Delete Buffer" })

-- lazygit
del("n", "<leader>gl")
del("n", "<leader>gL")
del("n", "<leader>gg")
del("n", "<leader>gG")
del("n", "<leader>gb")
-- map("n", "<leader>gl", function()
--   LazyVim.lazygit({
--     cwd = LazyVim.root.git(),
--   })
-- end, {
--   desc = "Lazygit (Root Dir)",
-- })
-- map("n", "<leader>gL", function()
--   LazyVim.lazygit()
-- end, {
--   desc = "Lazygit (cwd)",
-- })
map("n", "<leader>gg", function()
  LazyVim.lazygit({
    args = { "log" },
    cwd = LazyVim.root.git(),
  })
end, {
  desc = "Lazygit Log",
})
map("n", "<leader>gG", function()
  LazyVim.lazygit({
    args = { "log" },
  })
end, {
  desc = "Lazygit Log (cwd)",
})
