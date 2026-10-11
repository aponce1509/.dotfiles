-- Session layouts (profiles) for the WezTerm sessioner.
--
-- Model: docs/session-model.md §6. A layout is an ordered list of tabs; each
-- tab is an ordered list of panes. The first pane of a tab *is* the tab; later
-- panes are splits off the previous one.
--
-- Resolution order: exact id -> trait -> default.
--
-- Pane spec fields:
--   title    optional tab title
--   command  optional command typed into the tab's login shell (PATH-safe,
--            keeps a shell after it exits); see `args` to bypass the shell
--   args     optional argv table run directly, bypassing the shell
--   cwd      optional working directory, absolute or relative to the session root
--   split    optional "right" (default) | "left" | "top" | "bottom"

local wezterm = require 'wezterm'

local M = {}

-- Applied to any session with no more specific match. One shell tab, matching
-- the pre-profile behaviour.
M.default = {
  tabs = {
    { title = 'term', panes = { {} } },
  },
}

-- Keyed by exact session id (docs/session-model.md §5).
M.by_id = {
  -- Test fixture: see ~/ai-repos/sessioner-lab and its `feature` worktree.
  ['sessioner-lab@feature'] = {
    tabs = {
      { title = 'term', panes = { {} } },
      { title = 'herdr', panes = { { command = 'herdr' } } },
    },
  },
}

-- Ordered list; first trait whose marker exists in the session root wins.
-- Matching inspects the root with wezterm.glob (absolute paths), so a marker is
-- just a relative path, not code.
M.by_trait = {
  {
    name = 'rust',
    markers = { 'Cargo.toml' },
    layout = {
      tabs = {
        { title = 'term', panes = { {} } },
      },
    },
  },
  {
    name = 'python',
    markers = { 'pyproject.toml', 'setup.py', 'requirements.txt' },
    layout = {
      tabs = {
        { title = 'term', panes = { {} } },
      },
    },
  },
}

local split_dirs = { right = 'Right', left = 'Left', top = 'Top', bottom = 'Bottom' }

local function resolve_cwd(spec, root)
  if not spec.cwd or spec.cwd == '' then
    return root
  end
  if spec.cwd:sub(1, 1) == '/' then
    return spec.cwd
  end
  return root .. '/' .. spec.cwd
end

-- Run a pane's `command` by typing it into the pane's login shell. This keeps
-- the shell's PATH (GUI processes often lack ~/.local/bin) and leaves a shell
-- behind for the user. `args` bypasses this and runs a program directly.
local function apply_command(pane, spec)
  if spec.args then
    return
  end
  if spec.command and spec.command ~= '' then
    pane:send_text(spec.command .. '\n')
  end
end

local function apply_splits(pane, panes, root)
  for i = 2, #panes do
    local spec = panes[i] or {}
    local dir = split_dirs[(spec.split or 'right'):lower()] or 'Right'
    pane = pane:split({
      direction = dir,
      cwd = resolve_cwd(spec, root),
      args = spec.args,
    })
    apply_command(pane, spec)
  end
end

local function has_marker(root, marker)
  local ok, matches = pcall(wezterm.glob, root .. '/' .. marker)
  return ok and matches and #matches > 0
end

function M.resolve(id, root)
  local exact = M.by_id[id]
  if exact then
    return exact
  end
  if root then
    for _, trait in ipairs(M.by_trait) do
      for _, marker in ipairs(trait.markers) do
        if has_marker(root, marker) then
          return trait.layout
        end
      end
    end
  end
  return M.default
end

-- Spawn the layout as a new window (one workspace) and return the MuxWindow.
function M.open(workspace, root, layout)
  root = root or wezterm.home_dir
  layout = layout or M.default

  local first = layout.tabs[1] or { panes = { {} } }
  local first_pane = first.panes[1] or {}

  local tab, pane, win = wezterm.mux.spawn_window({
    cwd = resolve_cwd(first_pane, root),
    workspace = workspace,
    args = first_pane.args,
  })
  if first.title and first.title ~= '' then
    tab:set_title(first.title)
  end
  apply_command(pane, first_pane)
  apply_splits(pane, first.panes, root)

  for i = 2, #layout.tabs do
    local t = layout.tabs[i]
    local spec = t.panes[1] or {}
    local new_tab, new_pane = win:spawn_tab({
      cwd = resolve_cwd(spec, root),
      args = spec.args,
    })
    if t.title and t.title ~= '' then
      new_tab:set_title(t.title)
    end
    apply_command(new_pane, spec)
    apply_splits(new_pane, t.panes, root)
  end

  return win
end

return M
