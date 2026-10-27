# Session model

**Status: draft / design.** Nothing here is implemented yet. This captures the
concept so we can iterate on it later; the current behaviour is described in
[§7](#7-where-we-are-today) as the starting point.

**Decisions locked (2026-10-11).** Selection and naming are settled: every shape
is selectable (submodules and worktrees first-class; bares too, though
storage-only), and the session name collects the hierarchy — see
[§4](#4-repository-shapes-and-what-a-session-maps-to) and
[§5](#5-identity-and-naming). Implementation is still pending.

The goal is a single, multiplexer-agnostic definition of a *session* so the same
mental model works whether the backend is WezTerm (now), tmux, or zellij (parked
in `AGENTS.md`).

---

## 1. What is a session?

A **session** is one focused work context, realized as a multiplexer
workspace/session/window. A session is defined by three things:

1. **Identity** — a stable, unique name.
2. **Root** — the working directory every pane starts in.
3. **Layout** — the set of terminals (tabs/panes) to open, and what runs in each.

A session is almost always anchored to **one repository** (or one worktree of a
repository). "Start working on X" should mean: pick X, get a ready-made layout,
land in it.

It is explicitly **not**:

- a task runner or build tool,
- a git state manager (no automatic fetch/pull/branch switching),
- a replacement for the orchestrator layer (`herdr`) — see [§10](#10-open-questions).

---

## 2. Goals

- Select a repository and be dropped into a working layout in one step.
- One concept that maps cleanly onto every multiplexer.
- A **default profile** for any repo, plus **per-repo overrides**.
- Select any directory, plus any submodule or any worktree, as a session.
- Correctly understand repo topology: normal repos, submodules, bare repos,
  and worktrees.
- macOS and Windows parity.

## 3. Non-goals

- Managing git state.
- Auto-detecting "the right" toolchain beyond simple, explicit rules.
- Cross-machine session sync.

---

## 4. Repository shapes and what a session maps to

`directory_finder` classifies candidates; that classification drives naming and
rooting. **All shapes are selectable.** Worktrees and submodules are first-class;
a bare repo is selectable too but storage-only — it has no working tree, so
picking the bare itself anchors the session at the bare directory (picking one of
its worktrees is usually what you want).

| Shape                | What it is                               | Session root   | Session id ([§5](#5-identity-and-naming)) |
| -------------------- | ---------------------------------------- | -------------- | ----------------------------------------- |
| **Working repo**     | Normal clone with `.git` dir/file        | repo root      | `<path rel. to root>`                      |
| **Submodule**        | Repo nested inside another repo          | submodule root | `<superproject path>/<submodule path>`     |
| **Worktree**         | Extra working tree of a repo/bare        | worktree root  | `<repo>@<ref>`                             |
| **Bare repo**        | `.git`-style storage, no working tree    | the bare dir   | `<name>` (kept distinct, e.g. `x-git`)     |
| **Monorepo subdir**  | One repo, work happens in a subdirectory | chosen subdir  | `<path rel. to root>`                      |
| **Plain dir**        | Anything else                            | the dir        | `<path rel. to root>`                      |

`directory_finder` prints one line per hit. Default is
`(<type>)\t<path>`; `--ids` adds the computed session id as a middle column,
`(<type>)\t<id>\t<path>`. `<type>` is `git`, `bare`, `sub`, `wt`, or `dir`. It
walks a list of roots, expands leading `~`/`/`, canonicalizes each root, then:

- `git` — has `.git` and is inside a work tree, with the git dir equal to the
  common git dir.
- `sub` — as `git`, but `git rev-parse --show-superproject-working-tree` is
  non-empty (submodules live under a superproject).
- `bare` — has `HEAD`, is inside a git dir, and is not named `.git`.
- `wt` — git dir differs from the common git dir; also enumerated from every
  repo's `git worktree list --porcelain`.
- `dir` — everything else (only recursed into shallowly, to find repos).

Implemented behaviour (see `rust/directory_finder/README.md`):

- `sub` is a first-class type; submodule ids are the path relative to the root.
- `wt` entries carry a `<repo>@<ref>` id (`<short sha>` when detached).
- Worktrees are discovered from normal repos too, not just bares.
- Prunable / missing worktrees are skipped, as are bare and main-worktree
  entries from `git worktree list`.
- Roots are canonicalized (`/var` → `/private/var`) so walk paths match the
  absolute paths git reports.
- Ids are lowercased/slugged, collisions disambiguated (root prefix, then
  `~<hash>`), and capped at 64 chars.
- Relative paths are still not handled (roots expand from `$HOME`).

---

## 5. Identity and naming

Goal: the session name **collects the hierarchy**, so it is stable, unique, and
self-describing. Previously it was just the basename with `.` → `_`, so
`worktrees/python-core.git/main` and `.../feature` both collapsed to
`main` / `feature` and lost the repo; the picker now uses the **id** below.

Two layers:

- **id** — canonical, stable, unique. This is the mux session/workspace name and
  the key for layout overrides.
- **display** — optional short label; defaults to the id.

### 5.1 Building the id

The id is the selected candidate's path **relative to its discovery root**,
decorated by shape:

| Shape           | Rule                                | Selected path                               | id                                 |
| --------------- | ----------------------------------- | ------------------------------------------- | ---------------------------------- |
| **Worktree**    | `<repo>@<ref>`                      | `~/repos/worktrees/python-core.git/feature` | `python-core@feature`              |
| **Submodule**   | full rel. path from the root        | `~/repos/learning-git/modules/python-core`  | `learning-git/modules/python-core` |
| **Working repo**| rel. path from the root             | `~/repos/archive/cs-design-pattern`         | `archive/cs-design-pattern`        |
| **Plain dir**   | rel. path from the root             | `~/repos/ds-project`                        | `ds-project`                       |
| **Bare repo**   | basename, normalized, kept distinct | `~/repos/python-core.git`                   | `python-core-git`                  |

- **Worktree** — `<repo>` and `<ref>` come from git, not the path, so a worktree
  checked out anywhere still names correctly:
  `repo = basename(git -C <wt> rev-parse --git-common-dir)` (`.git` denuded),
  `ref = git -C <wt> rev-parse --abbrev-ref HEAD` (short SHA if detached). `@`
  (your preference) marks "this is a checkout of `<repo>`".
- **Submodule** — the full relative path says *which project owns it and where it
  sits*, so it never collides with a standalone `python-core`.
- **Collisions** — two roots can yield the same relative path (`repos/foo` vs
  `documents/foo`). On collision, prepend the root basename; if still equal,
  append `~<4-char hash of the absolute path>`.

### 5.2 Character limits (why `@` is safe, what actually breaks)

- **WezTerm workspace names are opaque labels** — the official docs call a
  workspace "just a label"; there is no documented charset or length limit.
  `@`, `/`, `.`, `-` render and switch fine (today's workspace is `_dotfiles`).
- **The real limit is the transport, not the name.** The picker reports back via
  OSC 1337 `SetUserVar=<base64>`. Some `base64` builds wrap at 76 columns; the
  injected newlines corrupt any payload over ~57 raw bytes. Here `base64` is BSD
  `/usr/bin/base64` (no wrap), so it works today — the picker must still emit
  `base64 | tr -d '\n'` to stay correct under GNU/coreutils and Windows.
- **Parked backends.** tmux rewrites `.` and `:` in session names to `_`; keep the
  id free of both so it survives if tmux returns.
- **Budget.** Soft cap **64 chars** for the status bar / launcher. Longer ids keep
  head + tail, drop middle segments, and append `~<4-char hash>`.

### 5.3 Normalization

`slug(segment)`: lowercase; spaces, `_`, `.`, `:`, and anything outside
`[a-z0-9@/-]` → `-`; collapse `-` runs; trim leading/trailing `-`. Segments join
with `/`; the worktree join uses `@`.

### 5.4 What the picker shows

One row per candidate, tagged by kind, single-select:

```txt
(wt)   python-core@feature        ~/repos/worktrees/python-core.git/feature
(sub)  learning-git/python-core   ~/repos/learning-git/python-core
(git)  python-core                ~/repos/python-core
(dir)  ds-project                 ~/repos/ds-project
(bare) python-core-git            ~/repos/python-core.git
```

The tag is for the eye; the id (middle column) is what becomes the session name.
fzf matches all columns; the path stays visible on the right.

---

## 6. Layouts and profiles

A **layout** is an ordered list of **tabs**; each tab is an ordered list of
**panes**. The first pane of a tab *is* the tab; later panes are splits off the
previous one.

Pane spec fields:

| field     | meaning                                                     |
| --------- | ----------------------------------------------------------- |
| `title`   | tab title (first pane of the tab)                           |
| `command` | command typed into the tab's login shell (keeps PATH)       |
| `args`    | argv run directly, bypassing the shell (overrides `command`) |
| `cwd`     | working dir; absolute, or relative to the session root      |
| `split`   | `right` (default) \| `left` \| `top` \| `bottom`            |

A **profile** is a named layout plus matching rules.

### Resolution order

1. **Exact id override** — `by_id[<session id>]` (§5).
2. **Trait default** — first trait whose marker file exists in the session root.
3. **Global default** — `default`, for anything with no more specific match.

### Registry (implemented)

Profiles live in **`wezterm/.config/wezterm/sessions.lua`** — separate from the
main WezTerm config and from the repo, so they survive clones and are never
committed by accident. Resolution and pane spawning live in that module;
`utils.lua`'s `switch-workspace` handler calls `sessions.resolve(id, root)` then
`sessions.open(name, root, layout)`.

```lua
-- wezterm/.config/wezterm/sessions.lua
M.default = {
  tabs = { { title = 'term', panes = { { command = 'zsh -l' } } } },
}

M.by_id = {
  ['python-core@feature'] = {
    tabs = {
      { title = 'term',  panes = { { command = 'zsh -l' } } },
      { title = 'tests', panes = { { command = 'pytest -q' } } },
    },
  },
}

M.by_trait = {
  { name = 'rust', markers = { 'Cargo.toml' }, layout = { tabs = { ... } } },
}
```

Trait detection inspects the session root with `wezterm.glob` (absolute
patterns), so the marker list is data, not code.

> Deviation from the earlier sketch: the format is **Lua**, not TOML, and it sits
> in the WezTerm config dir. WezTerm's config Lua has no file-read API, so a TOML
> registry would need a vendored parser; a Lua module keeps macOS and Windows
> WezTerm on one registry for free and leaves the picker unchanged (it still
> sends only `{cmd, name, cwd}`). A picker-resolved TOML registry
> (backend-independent per §8) remains a possible future move; the pane/layout
> schema above would carry over verbatim.

---

## 7. Where we are today

Everything below is the **current** implementation; the sections above describe
where we want to take it.

Flow:

1. WezTerm leader is `Ctrl+a`. `Ctrl+a f` calls `wez_sessioner_auxiliar`
   (`wezterm/.config/wezterm/utils.lua`), which spawns a tab running
   `tmux-sessioner [dir]`. `Ctrl+a i` does the same rooted at `~/.dotfiles`.
2. `bin/.local/scripts/tmux-sessioner` detects `WEZTERM_CONFIG_DIR` and delegates
   to `wez-sessioner`.
3. `bin/.local/scripts/wez-sessioner` runs
   `directory_finder <roots> --depth 1 --ids | fzf --delimiter=$'\t'
   --with-nth=2,3 --nth=2,3`, takes the **id** column as the session name, then
   emits an escape sequence:
   `\033]1337;SetUserVar=hacky-user-command=<base64 json>` (the base64 is piped
   through `tr -d '\n'`) carrying `{cmd: "switch-workspace", name: <id>, cwd}`,
   then kills the picker pane.
4. `utils.lua` handles `user-var-changed` and `switch-workspace` resolves the
   session's profile (`sessions.resolve(id, root)`, §6), then creates or
   switches a WezTerm **workspace** named after the id: `sessions.open` spawns
   the layout's tabs/panes with `cwd = <path>`.

So today a "session" == a WezTerm workspace named after the id, rendered from
its resolved profile (an exact-id override, else a trait default, else one shell
tab). (`tmux-sessioner` keeps the same picker for the parked non-WezTerm path,
naming tmux sessions with the id.)

Existing gaps to close:

- The script is still named `tmux-sessioner` even though tmux is parked.
- Profiles are WezTerm-only; the backend-independent registry of §8 is future work.

---

## 8. Multiplexer abstraction

Describe a session once; each backend renders it.

| Concept    | WezTerm     | tmux         | zellij       |
| ---------- | ----------- | ------------ | ------------ |
| Session    | Workspace   | Session      | Session      |
| Layout     | Tabs/Panes  | Windows/Panes | Tabs/Panes  |
| Create cwd | `spawn_window { cwd }` | `new-session -c` | `--cwd` |
| Switch     | `set_active_workspace` | `switch-client` | `attach` |
| Kill       | `kill-pane` | `kill-session` | `kill-session` |

Backend interface (minimal):

```txt
list()                     -> [session]
create(id, root, profile)  -> session
switch(id)                 -> ()
kill(id)                   -> ()
```

The picker (discovery + fzf + profile resolution) is backend-independent; only
the final "create/switch" step is per-multiplexer.

---

## 9. Configuration

- Profiles/overrides live in one registry file, separate from the main WezTerm
  config: **`wezterm/.config/wezterm/sessions.lua`** (§6).
- Discovery roots are still hard-coded in the sessioner scripts
  (`bin/.local/scripts/{wez-,}tmux-sessioner`, `windows/wez-sessioner.ps1`).
  `wez-sessioner` lists only `~/ai-repos` and `~/ai-repos/ales-os`; the other
  scripts keep `~/repos`, `~/ai-repos`,
  `~/repos/programming-reference/python/apm_python_ref`, `~/OneDrive/Documents`,
  plus the ad hoc `~/.dotfiles` (from `Ctrl+a i`).
  Making them configurable is still open.
- Windows uses a parallel config path; keep the schema identical.

Resolved: **Lua** for the registry, with **trait detection in the tool** (marker
files checked with `wezterm.glob`). See the deviation note in §6.

---

## 10. Open questions

- ~~**Naming**: exact id/slug rules for collisions and worktrees.~~ Resolved — [§5](#5-identity-and-naming).
- ~~**Where config lives** and its format.~~ Resolved — Lua registry at
  `wezterm/.config/wezterm/sessions.lua` (§6).
- ~~**Trait detection**: how to decide a repo "is Rust/Python/...".~~ Resolved —
  marker files (e.g. `Cargo.toml`) checked with `wezterm.glob` in the registry.
- ~~**Discovery**: add a `sub` type; emit `<repo>@<ref>` metadata for
  worktrees.~~ Resolved — done in `rust/directory_finder` (§4). Remaining:
  make roots + `--depth` configurable.
- ~~**Bare as a root**~~ Resolved — bares stay selectable but storage-only; picking
  one anchors the session at the bare directory (no working tree).
- **herdr interaction**: sessions (L3/L4) vs the orchestrator (L4) — do they
  compose or overlap?
- **Chord**: `todo-keys.md` still lists the sessioner triggers as unresolved
  (`^f` / `^g`). Today it is `Ctrl+a f` / `Ctrl+a i` in WezTerm.
- ~~**Windows**: PowerShell parity for discovery + install.~~ Resolved — the
  Windows picker uses `--ids` too (JSON via `ConvertTo-Json`); `rust/install.ps1`
  covers install.
- **Rename**: drop the `tmux-sessioner` name once the concept is split out.

---

## 11. Related files

| Concern              | File                                                     |
| -------------------- | -------------------------------------------------------- |
| Discovery (source)   | `rust/directory_finder/`                                  |
| Picker (WezTerm)     | `bin/.local/scripts/wez-sessioner`                        |
| Picker (dispatch)    | `bin/.local/scripts/tmux-sessioner`                       |
| Picker (Windows)     | `bin/.local/scripts/windows/wez-sessioner.ps1`            |
| Workspace creation   | `wezterm/.config/wezterm/utils.lua`                       |
| Profiles / layouts   | `wezterm/.config/wezterm/sessions.lua`                    |
| Keys                 | `wezterm/.wezterm.lua`                                    |
| Layer contract       | `AGENTS.md`, `todo-keys.md`                               |
