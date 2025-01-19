-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action
local windows_os = require("windows")
local mac_os = require("macos")
local utils = require("utils")

-- This will hold the configuration.
local config = wezterm.config_builder()
wezterm.log_info(os.getenv("SECOND_BRAIN_PATH"))

wezterm.on('user-var-changed', function(window, pane, name, value)
  if name == 'hacky-user-command' then
    local cmd_context = wezterm.json_parse(value)
    wezterm.log_info(cmd_context)
    utils.hacky_user_commands[cmd_context.cmd](window, pane, cmd_context)
  end
end)

wezterm.on('update-right-status', function(window, pane)
  local leader = ''
  if window:leader_is_active() then
    leader = 'LEADER'
  end
  window:set_right_status(leader .. " " .. window:active_workspace() .. "   ")
end)

wezterm.on("trigger-workspace", function(window, pane)
  -- window:set_right_status("holaholaholaholaholaholaholaholaholaholaaao")
  local workspace = utils:create_workspace_with_tabs()
  wezterm.log_info("Workspace created: " .. workspace)
end)

wezterm.on("wez-sessioner", function(window, pane)
  wezterm.log_info(window)
  wezterm.log_info(pane)
  local mux_window = pane:window()
  local _, temp_pane, _ = mux_window:spawn_tab({})
  temp_pane:send_text("tmux-sessioner\n")

  -- local temp_tab, temp_pane, temp_window = wezterm.mux.spawn_window({ workspace = "temp" })
  -- temp_pane:send_text("tmux-sessioner\n")
  -- wezterm.mux.set_active_workspace("temp")
end)

-- ColorScheme
config.color_scheme = 'Catppuccin Macchiato (Gogh)'

-- Fonts
config.font_size = 13.0
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")

-- Launch Menu
if utils.os_name == "macOS" then
  config.launch_menu = mac_os.launch_menu
elseif utils.os_name == "Windows" then
  config.launch_menu = windows_os.launch_menu
end

-- Keys
config.leader = { key = "a", mods = "CTRL" }
config.keys = {
  {
    key = 'w',
    mods = 'LEADER',
    action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' },
  },
  {
    key = "o",
    mods = "LEADER",
    action = wezterm.action.EmitEvent("trigger-workspace"),
  },
  { key = 'n', mods = 'CTRL',  action = act.SwitchWorkspaceRelative(1) },
  { key = 'p', mods = 'CTRL',  action = act.SwitchWorkspaceRelative(-1) },
  { key = 'l', mods = 'SUPER', action = wezterm.action.ShowLauncher },
  {
    key = 'W',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = 'Enter name for new workspace' },
      },
      action = wezterm.action_callback(function(window, pane, line)
        wezterm.log_info("Created and switched to workspace: ")
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:perform_action(
            act.SwitchToWorkspace {
              name = line,
            },
            pane
          )
        end
      end),
    },
  },
  -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
  {
    key = "J",
    mods = "LEADER", -- Use "CTRL" or "ALT" or other modifiers as needed
    action = wezterm.action_callback(function(window, _)
      utils.create_notes_workspace()
    end),
  },
  {
    key = "f",
    mods = "LEADER", -- Use "CTRL" or "ALT" or other modifiers as needed
    action = wezterm.action_callback(function(window, _)
      utils.wez_sessioner_auxiliar(window)
    end),
  },
  {
    key = "i",
    mods = "LEADER",
    action = wezterm.action_callback(function(window, _)
      utils.wez_sessioner_auxiliar(window, os.getenv("HOME") .. "/.dotfiles")
    end),
  },
  { key = "a",          mods = "LEADER|CTRL",  action = wezterm.action { SendString = "\x01" } },
  { key = "s",          mods = "LEADER",       action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } } },
  { key = "v",          mods = "LEADER",       action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } } },
  { key = "z",          mods = "LEADER",       action = "TogglePaneZoomState" },
  { key = "c",          mods = "LEADER",       action = wezterm.action { SpawnTab = "CurrentPaneDomain" } },
  { key = "u",          mods = "LEADER",       action = wezterm.action { SpawnTab = "CurrentPaneDomain" } },
  { key = "h",          mods = "LEADER",       action = wezterm.action { ActivatePaneDirection = "Left" } },
  { key = "j",          mods = "LEADER",       action = wezterm.action { ActivatePaneDirection = "Down" } },
  { key = "k",          mods = "LEADER",       action = wezterm.action { ActivatePaneDirection = "Up" } },
  { key = "l",          mods = "LEADER",       action = wezterm.action { ActivatePaneDirection = "Right" } },
  -- { key = "H",          mods = "LEADER|SHIFT", action = wezterm.action { AdjustPaneSize = { "Left", 5 } } },
  -- { key = "J",          mods = "LEADER|SHIFT", action = wezterm.action { AdjustPaneSize = { "Down", 5 } } },
  -- { key = "K",          mods = "LEADER|SHIFT", action = wezterm.action { AdjustPaneSize = { "Up", 5 } } },
  -- { key = "L",          mods = "LEADER|SHIFT", action = wezterm.action { AdjustPaneSize = { "Right", 5 } } },
  { key = "1",          mods = "LEADER",       action = wezterm.action { ActivateTab = 0 } },
  { key = "2",          mods = "LEADER",       action = wezterm.action { ActivateTab = 1 } },
  { key = "3",          mods = "LEADER",       action = wezterm.action { ActivateTab = 2 } },
  { key = "4",          mods = "LEADER",       action = wezterm.action { ActivateTab = 3 } },
  { key = "5",          mods = "LEADER",       action = wezterm.action { ActivateTab = 4 } },
  { key = "6",          mods = "LEADER",       action = wezterm.action { ActivateTab = 5 } },
  { key = "7",          mods = "LEADER",       action = wezterm.action { ActivateTab = 6 } },
  { key = "8",          mods = "LEADER",       action = wezterm.action { ActivateTab = 7 } },
  { key = "9",          mods = "LEADER",       action = wezterm.action { ActivateTab = 8 } },
  { key = "&",          mods = "LEADER|SHIFT", action = wezterm.action { CloseCurrentTab = { confirm = true } } },
  { key = "x",          mods = "LEADER",       action = wezterm.action { CloseCurrentPane = { confirm = true } } },
  { key = 'LeftArrow',  mods = 'SHIFT',        action = act.ActivateTabRelative(-1) },
  { key = 'RightArrow', mods = 'SHIFT',        action = act.ActivateTabRelative(1) },

  { key = "n",          mods = "SHIFT|CTRL",   action = "ToggleFullScreen" },
  { key = "v",          mods = "SHIFT|CTRL",   action = wezterm.action.PasteFrom 'Clipboard' },
  { key = "c",          mods = "SHIFT|CTRL",   action = wezterm.action.CopyTo 'Clipboard' },
  { key = "+",          mods = "SHIFT|CTRL",   action = "IncreaseFontSize" },
  { key = "-",          mods = "SHIFT|CTRL",   action = "DecreaseFontSize" },
  { key = "0",          mods = "SHIFT|CTRL",   action = "ResetFontSize" },
}

return config
