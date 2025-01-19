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
-- del("n", "/")
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
-- del("t", "<esc><esc>")
-- del("t", "<C-h>")
-- del("t", "<C-j>")
-- del("t", "<C-k>")
-- del("t", "<C-l>")
-- del("t", "<C-/>")
-- del("t", "<c-_>")

-- buffers
del("n", "<S-h>")
del("n", "<S-l>")

map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<leader>q", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })

-- Python
map("n", "<leader>nc", "O# %%<ESC>j", { noremap = true })
map("n", "<leader>nm", "O# %% [markdown]<CR> <ESC>", { noremap = true })


-- Markdown
map("n", "<leader>p", ":lua require('nabla').popup({border = 'rounded'})<CR>", { desc = "Latex. Preview Equation" })
map("n", "<leader>mr", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":spellr\n", true, false, true), "m", true)
end, { desc = "[P]Spelling repeat" })
map("v", "<leader>mb", function()
  -- Get the selected text range
  local start_row, start_col = unpack(vim.fn.getpos("'<"), 2, 3)
  local end_row, end_col = unpack(vim.fn.getpos("'>"), 2, 3)
  -- Get the selected lines
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  local selected_text = table.concat(lines, "\n"):sub(start_col, #lines == 1 and end_col or -1)
  if selected_text:match("^%*%*.*%*%*$") then
    vim.notify("Text already bold", vim.log.levels.INFO)
  else
    vim.cmd("normal 2gsa*")
  end
end, { desc = "[P]BOLD current selection" })
-- Function to delete the current file with confirmation
local function delete_current_file()
  local current_file = vim.fn.expand("%:p")
  if current_file and current_file ~= "" then
    -- Check if trash utility is installed
    if vim.fn.executable("trash") == 0 then
      vim.api.nvim_echo({
        { "- Trash utility not installed. Make sure to install it first\n", "ErrorMsg" },
        { "- In macOS run `brew install trash`\n",                          nil },
      }, false, {})
      return
    end
    -- Prompt for confirmation before deleting the file
    vim.ui.input({
      prompt = "Type 'del' to delete the file '" .. current_file .. "': ",
    }, function(input)
      if input == "del" then
        -- Delete the file using trash app
        local success, _ = pcall(function()
          vim.fn.system({ "trash", vim.fn.fnameescape(current_file) })
        end)
        if success then
          vim.api.nvim_echo({
            { "File deleted from disk:\n", "Normal" },
            { current_file,                "Normal" },
          }, false, {})
          -- Close the buffer after deleting the file
          vim.cmd("bd!")
        else
          vim.api.nvim_echo({
            { "Failed to delete file:\n", "ErrorMsg" },
            { current_file,               "ErrorMsg" },
          }, false, {})
        end
      else
        vim.api.nvim_echo({
          { "File deletion canceled.", "Normal" },
        }, false, {})
      end
    end)
  else
    vim.api.nvim_echo({
      { "No file to delete", "WarningMsg" },
    }, false, {})
  end
end

-- Keymap to delete the current file
vim.keymap.set("n", "<leader>fD", function()
  delete_current_file()
end, { desc = "[P]Delete current file" })
-- -- Multiline unbold attempt
-- -- In normal mode, bold the current word under the cursor
-- -- If already bold, it will unbold the word under the cursor
-- -- If you're in a multiline bold, it will unbold it only if you're on the
-- -- first line
map("n", "<leader>mb", function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_buffer = vim.api.nvim_get_current_buf()
  local start_row = cursor_pos[1] - 1
  local col = cursor_pos[2]
  -- Get the current line
  local line = vim.api.nvim_buf_get_lines(current_buffer, start_row, start_row + 1, false)[1]
  -- Check if the cursor is on an asterisk
  if line:sub(col + 1, col + 1):match("%*") then
    vim.notify("Cursor is on an asterisk, run inside the bold text", vim.log.levels.WARN)
    return
  end
  -- Search for '**' to the left of the cursor position
  local left_text = line:sub(1, col)
  local bold_start = left_text:reverse():find("%*%*")
  if bold_start then
    bold_start = col - bold_start
  end
  -- Search for '**' to the right of the cursor position and in following lines
  local right_text = line:sub(col + 1)
  local bold_end = right_text:find("%*%*")
  local end_row = start_row
  while not bold_end and end_row < vim.api.nvim_buf_line_count(current_buffer) - 1 do
    end_row = end_row + 1
    local next_line = vim.api.nvim_buf_get_lines(current_buffer, end_row, end_row + 1, false)[1]
    if next_line == "" then
      break
    end
    right_text = right_text .. "\n" .. next_line
    bold_end = right_text:find("%*%*")
  end
  if bold_end then
    bold_end = col + bold_end
  end
  -- Remove '**' markers if found, otherwise bold the word
  if bold_start and bold_end then
    -- Extract lines
    local text_lines = vim.api.nvim_buf_get_lines(current_buffer, start_row, end_row + 1, false)
    local text = table.concat(text_lines, "\n")
    -- Calculate positions to correctly remove '**'
    -- vim.notify("bold_start: " .. bold_start .. ", bold_end: " .. bold_end)
    local new_text = text:sub(1, bold_start - 1) .. text:sub(bold_start + 2, bold_end - 1) .. text:sub(bold_end + 2)
    local new_lines = vim.split(new_text, "\n")
    -- Set new lines in buffer
    vim.api.nvim_buf_set_lines(current_buffer, start_row, end_row + 1, false, new_lines)
    -- vim.notify("Unbolded text", vim.log.levels.INFO)
  else
    -- Bold the word at the cursor position if no bold markers are found
    local before = line:sub(1, col)
    local after = line:sub(col + 1)
    local inside_surround = before:match("%*%*[^%*]*$") and after:match("^[^%*]*%*%*")
    if inside_surround then
      vim.cmd("normal gsd*.")
    else
      vim.cmd("normal viw")
      vim.cmd("normal 2gsa*")
    end
    vim.notify("Bolded current word", vim.log.levels.INFO)
  end
end, { desc = "[P]BOLD toggle bold markers" })

map("v", "<leader>mh", function()
  -- Get the selected text range
  local start_row, start_col = unpack(vim.fn.getpos("'<"), 2, 3)
  local end_row, end_col = unpack(vim.fn.getpos("'>"), 2, 3)
  -- Get the selected lines
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  local selected_text = table.concat(lines, "\n"):sub(start_col, #lines == 1 and end_col or -1)
  if selected_text:match("^%=%=.*%=%=$") then
    vim.notify("Text already bold", vim.log.levels.INFO)
  else
    vim.cmd("normal 2gsa=")
  end
end, { desc = "[P]Highlight current selection" })
map("n", "<leader>mh", function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_buffer = vim.api.nvim_get_current_buf()
  local start_row = cursor_pos[1] - 1
  local col = cursor_pos[2]
  -- Get the current line
  local line = vim.api.nvim_buf_get_lines(current_buffer, start_row, start_row + 1, false)[1]
  -- Check if the cursor is on an asterisk
  if line:sub(col + 1, col + 1):match("%=") then
    vim.notify("Cursor is on an asterisk, run inside the bold text", vim.log.levels.WARN)
    return
  end
  -- Search for '**' to the left of the cursor position
  local left_text = line:sub(1, col)
  local bold_start = left_text:reverse():find("%=%=")
  if bold_start then
    bold_start = col - bold_start
  end
  -- Search for '**' to the right of the cursor position and in following lines
  local right_text = line:sub(col + 1)
  local bold_end = right_text:find("%=%=")
  local end_row = start_row
  while not bold_end and end_row < vim.api.nvim_buf_line_count(current_buffer) - 1 do
    end_row = end_row + 1
    local next_line = vim.api.nvim_buf_get_lines(current_buffer, end_row, end_row + 1, false)[1]
    if next_line == "" then
      break
    end
    right_text = right_text .. "\n" .. next_line
    bold_end = right_text:find("%=%=")
  end
  if bold_end then
    bold_end = col + bold_end
  end
  -- Remove '**' markers if found, otherwise bold the word
  if bold_start and bold_end then
    -- Extract lines
    local text_lines = vim.api.nvim_buf_get_lines(current_buffer, start_row, end_row + 1, false)
    local text = table.concat(text_lines, "\n")
    -- Calculate positions to correctly remove '**'
    -- vim.notify("bold_start: " .. bold_start .. ", bold_end: " .. bold_end)
    local new_text = text:sub(1, bold_start - 1) .. text:sub(bold_start + 2, bold_end - 1) .. text:sub(bold_end + 2)
    local new_lines = vim.split(new_text, "\n")
    -- Set new lines in buffer
    vim.api.nvim_buf_set_lines(current_buffer, start_row, end_row + 1, false, new_lines)
    -- vim.notify("Unbolded text", vim.log.levels.INFO)
  else
    -- Bold the word at the cursor position if no bold markers are found
    local before = line:sub(1, col)
    local after = line:sub(col + 1)
    local inside_surround = before:match("%=%=[^%=]*$") and after:match("^[^%=]*%=%=")
    if inside_surround then
      vim.cmd("normal gsd=.")
    else
      vim.cmd("normal viw")
      vim.cmd("normal 2gsa=")
    end
    vim.notify("Bolded current word", vim.log.levels.INFO)
  end
end, { desc = "[P]BOLD toggle Highlight markers" })
map({ "n", "v" }, "gk", function()
  -- `?` - Start a search backwards from the current cursor position.
  -- `^` - Match the beginning of a line.
  -- `##` - Match 2 ## symbols
  -- `\\+` - Match one or more occurrences of prev element (#)
  -- `\\s` - Match exactly one whitespace character following the hashes
  -- `.*` - Match any characters (except newline) following the space
  -- `$` - Match extends to end of line
  vim.cmd("silent! ?^##\\+\\s.*$")
  -- Clear the search highlight
  vim.cmd("nohlsearch")
end, { desc = "[P]Go to previous markdown header" })
map({ "n", "v" }, "gj", function()
  -- `/` - Start a search forwards from the current cursor position.
  -- `^` - Match the beginning of a line.
  -- `##` - Match 2 ## symbols
  -- `\\+` - Match one or more occurrences of prev element (#)
  -- `\\s` - Match exactly one whitespace character following the hashes
  -- `.*` - Match any characters (except newline) following the space
  -- `$` - Match extends to end of line
  vim.cmd("silent! /^##\\+\\s.*$")
  -- Clear the search highlight
  vim.cmd("nohlsearch")
end, { desc = "[P]Go to next markdown header" })
map("n", "zu", function()
  -- map("n", "<leader>mfu", function()
  -- Reloads the file to reflect the changes
  vim.cmd("edit!")
  vim.cmd("normal! zR") -- Unfold all headings
end, { desc = "[P]Unfold all headings level 2 or above" })

-- Folds
vim.keymap.set("n", "<CR>", function()
  -- Get the current line number
  local line = vim.fn.line(".")
  -- Get the fold level of the current line
  local foldlevel = vim.fn.foldlevel(line)
  if foldlevel == 0 then
    vim.notify("No fold found", vim.log.levels.INFO)
  else
    vim.cmd("normal! za")
  end
end, { desc = "[P]Toggle fold" })

local function set_foldmethod_expr()
  -- These are lazyvim.org defaults but setting them just in case a file
  -- doesn't have them set
  if vim.fn.has("nvim-0.10") == 1 then
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
    vim.opt.foldtext = ""
  else
    vim.opt.foldmethod = "indent"
    vim.opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
  end
  vim.opt.foldlevel = 99
end

-- Function to fold all headings of a specific level
local function fold_headings_of_level(level)
  -- Move to the top of the file
  vim.cmd("normal! gg")
  -- Get the total number of lines
  local total_lines = vim.fn.line("$")
  for line = 1, total_lines do
    -- Get the content of the current line
    local line_content = vim.fn.getline(line)
    -- "^" -> Ensures the match is at the start of the line
    -- string.rep("#", level) -> Creates a string with 'level' number of "#" characters
    -- "%s" -> Matches any whitespace character after the "#" characters
    -- So this will match `## `, `### `, `#### ` for example, which are markdown headings
    if line_content:match("^" .. string.rep("#", level) .. "%s") then
      -- Move the cursor to the current line
      vim.fn.cursor(line, 1)
      -- Fold the heading if it matches the level
      if vim.fn.foldclosed(line) == -1 then
        vim.cmd("normal! za")
      end
    end
  end
end

local function fold_markdown_headings(levels)
  set_foldmethod_expr()
  -- I save the view to know where to jump back after folding
  local saved_view = vim.fn.winsaveview()
  for _, level in ipairs(levels) do
    fold_headings_of_level(level)
  end
  vim.cmd("nohlsearch")
  -- Restore the view to jump to where I was
  vim.fn.winrestview(saved_view)
end

-- gk jummps to the markdown heading above and then folds it
-- zi by default toggles folding, but I don't need it lamw25wmal
map("n", "zj", function()
  -- Difference between normal and normal!
  -- - `normal` executes the command and respects any mappings that might be defined.
  -- - `normal!` executes the command in a "raw" mode, ignoring any mappings.
  vim.cmd("normal gk")
  -- This is to fold the line under the cursor
  vim.cmd("normal! za")
end, { desc = "[P]Fold the heading cursor currently on" })

-- Keymap for folding markdown headings of level 1 or above
map("n", "zI", function()
  -- map("n", "<leader>mfj", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2, 1 })
end, { desc = "[P]Fold all headings level 1 or above" })

-- Keymap for folding markdown headings of level 2 or above
-- I know, it reads like "madafaka" but "k" for me means "2"
map("n", "zk", function()
  -- map("n", "<leader>mfk", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2 })
end, { desc = "[P]Fold all headings level 2 or above" })

-- Keymap for folding markdown headings of level 3 or above
map("n", "zl", function()
  -- map("n", "<leader>mfl", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3 })
end, { desc = "[P]Fold all headings level 3 or above" })

-- Keymap for folding markdown headings of level 4 or above
map("n", "z;", function()
  -- map("n", "<leader>mf;", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4 })
end, { desc = "[P]Fold all headings level 4 or above" })
-- lazygit prefiero que lo intuitivo sea en el root
-- del("n", "<leader>gl")
-- del("n", "<leader>gL")
-- del("n", "<leader>gg")
-- del("n", "<leader>gG")
-- del("n", "<leader>gb")
-- map("n", "<leader>gl", function()
--   Snacks.lazygit({
--     cwd = LazyVim.root.git(),
--   })
-- end, {
--   desc = "Lazygit (Root Dir)",
-- })
-- map("n", "<leader>gL", function()
--   Snacks.lazygit()
-- end, {
--   desc = "Lazygit (cwd)",
-- })
-- -- map("n", "<leader>gl", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
-- map("n", "<leader>gg", function()
--   Snacks.lazygit({
--     args = { "log" },
--     cwd = LazyVim.root.git(),
--   })
-- end, {
--   desc = "Lazygit Log",
-- })
-- map("n", "<leader>gG", function()
--   Snacks.lazygit({
--     args = { "log" },
--   })
-- end, {
--   desc = "Lazygit Log (cwd)",
-- })
-- map("n", "<leader>gf", function() Snacks.lazygit.log_file() end, { desc = "Lazygit Current File History" })
-- map("n", "<leader>gl", function() Snacks.lazygit.log({ cwd = LazyVim.root.git() }) end, { desc = "Lazygit Log" })
-- map("n", "<leader>gL", function() Snacks.lazygit.log() end, { desc = "Lazygit Log (cwd)" })
