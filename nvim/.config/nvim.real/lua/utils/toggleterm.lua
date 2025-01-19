---@type rustaceanvim.Executor
local M = {
  execute_command = function(command, args, cwd, _)
    local ok, term = pcall(require, 'toggleterm.terminal')
    if not ok then
      vim.schedule(function()
        vim.notify('toggleterm not found.', vim.log.levels.ERROR)
      end)
      return
    end

    local shell = require('rustaceanvim.shell')
    -- print(shell.make_command_from_args(command, args))
    term.Terminal:new({
      direction = "vertical",
      display_name = "runner",
      start_in_insert = false,
      hidden = false,
      name = "rust",
      dir = cwd,
      cmd = shell.make_command_from_args(command, args),
      close_on_exit = false,
    }):toggle()
  end,
}

return M
