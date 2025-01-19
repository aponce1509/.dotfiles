local M = {}
local wezterm = require 'wezterm'

M.os_name = package.config:sub(1, 1) == "/" and "macOS" or "Windows"

wezterm.log_info()
function M.wez_sessioner_auxiliar(window, dir)
  local path = dir or ""
  local cmd_to_pane = "tmux-sessioner" .. " " .. path -- .. " --kill"
  local _, temp_pane, _ = window:mux_window():spawn_tab({})
  temp_pane:send_text(cmd_to_pane .. "\n")
end

-- Function to create a workspace with 3 tabs, one having nvim opened
function M.create_workspace_with_tabs()
  local workspace_name = "coding"

  -- Check if the workspace already exists
  local existing_workspaces = wezterm.mux.get_workspace_names()

  -- If the workspace exists, switch to it
  for _, name in ipairs(existing_workspaces) do
    if name == workspace_name then
      wezterm.mux.set_active_workspace(workspace_name)
      wezterm.log_info("Switched to existing workspace: " .. workspace_name)
      return workspace_name
    end
  end

  -- If the workspace doesn't exist, create it
  local default_tab, _, window = wezterm.mux.spawn_window({
    cwd = os.getenv("HOME") .. "/repos/",
    arg = { "zsh", "-l" },
    workspace = workspace_name,
  })

  default_tab:set_title("Terminal")
  local nvim_tab, nvim_pane, _ = window:spawn_tab({})
  nvim_pane:send_text("nvim\n")
  nvim_tab:set_title("Editor")

  wezterm.mux.set_active_workspace(workspace_name)
  wezterm.log_info("Created and switched to workspace: " .. workspace_name)

  return workspace_name
end

function M.create_notes_workspace()
  local workspace_name = "notes"

  -- Check if the workspace already exists
  local existing_workspaces = wezterm.mux.get_workspace_names()

  -- If the workspace exists, switch to it
  for _, name in ipairs(existing_workspaces) do
    if name == workspace_name then
      wezterm.mux.set_active_workspace(workspace_name)
      wezterm.log_info("Switched to existing workspace: " .. workspace_name)
      return workspace_name
    end
  end

  -- If the workspace doesn't exist, create it
  local default_tab, _, window = wezterm.mux.spawn_window({
    cwd = os.getenv("SECOND_BRAIN_PATH"),
    arg = { "zsh", "-l" },
    workspace = workspace_name,
  })

  default_tab:set_title("Terminal")
  local nvim_tab, nvim_pane, _ = window:spawn_tab({})
  local todo_tab, todo_pane, _ = window:spawn_tab({})

  -- nvim_pane:send_text("nvim\n")
  nvim_tab:set_title("Editor")

  todo_pane:send_text("cd todos && nvim\n")
  todo_tab:set_title("TODOs")

  wezterm.mux.set_active_workspace(workspace_name)
  wezterm.log_info("Created and switched to workspace: " .. workspace_name)
  wezterm.log_info(os.getenv('SECOND_BRAIN_PATH'))
  wezterm.log_info(os.getenv("SECOND_BRAIN_PATH"))

  return workspace_name
end

M.hacky_user_commands = {

  ['switch-workspace'] = function(window, pane, cmd_context)
    local workspace_name = cmd_context.name
    local current_workspace = window:active_workspace()

    if current_workspace == workspace_name then
      return -- Already in the requested workspace, do nothing
    end

    -- Check if the workspace exists
    local exists = false
    for _, ws in ipairs(wezterm.mux.get_workspace_names()) do
      if ws == workspace_name then
        exists = true
        break
      end
    end

    if exists then
      -- Switch to the existing workspace
      wezterm.mux.set_active_workspace(workspace_name)
    else
      local new_tab, _, new_window = wezterm.mux.spawn_window({
        cwd = cmd_context.cwd,
        workspace = workspace_name,
      })
      wezterm.mux.set_active_workspace(workspace_name)
    end
  end,
}



return M
