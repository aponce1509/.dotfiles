# AGENTS.md

- One contract for every keyboard layer on this machine.
- Goal: layers behave the same way; adding a binding is mechanical; a chord is
  answered by walking layers top→bottom.
- Scope: system, window manager, terminal emulator, multiplexer, orchestrator,
  harness, editor, TUIs.

## Current stack (minimal)

- L0 macOS.
- L1 yabai + skhd (WM).
- L2 wezterm (terminal emulator).
- L3 wezterm (built-in mux, leader Ctrl+a).
- L4 herdr (orchestrator).
- L5 opencode / codex (harness).
- L6 nvim (editor).
- Parked (not in stack): tmux, zellij, alacritty, kitty, vscode.
- Rule: adding any tool to the stack requires a conflict review (§8).

## 1. Element hierarchy

```txt
macOS
├─ system keys                          Cmd-*                   always active
├─ yabai + skhd (WM)                    Opt-*                   always active
└─ wezterm                              Cmd-*, Ctrl+Shift-*     terminal emulator
   ├─ wezterm mux (built-in)            leader Ctrl+a           mux
   └─ herdr (orchestrator)              leader Ctrl+b           in-terminal
      ├─ opencode / codex (harness)     leader Ctrl+o           in-terminal
      └─ nvim (editor)                  leader Space, local \   in-terminal
         └─ TUIs (lazygit, btop, …)     free                    in-terminal
```

## 2. Activation model

```txt
[L0 system + L1 WM]  ── always active, global, win first
        │  (key not consumed above falls through)
        ▼
[L2 terminal emulator] ── active only when focused
        ▼
[L3 mux] → [L4 orchestrator] → [L5 harness] → [L6 editor] → [L7 TUI]
            innermost layer receives the key last
```

- L0/L1 are always active → their chords are never "free" for inner layers.
- L2 receives a key only if L0/L1 did not take it.
- L3–L7 receive only unclaimed keys, innermost-focused layer first.
- Resolve a chord = first layer in the chain that claims it.

## 3. Ctrl is per-program, not per-layer (runtime plane)

- A terminal host only owns its leader/prefix and passes raw `Ctrl+<letter>`
  through.
- Raw `Ctrl+<letter>` belongs to the **innermost focused in-terminal program**.
- Same host + different program → different meaning for the same chord.

```txt
host: wezterm / mux / herdr   owns leader only, passes Ctrl+<letter> down
   └─ focused program         owns raw Ctrl+<letter>
      ├─ shell / readline     Ctrl+p/n, Ctrl+r, Ctrl+l, Ctrl+u/w, Ctrl+c/d/z
      ├─ nvim                 Ctrl+hjkl window nav (normal mode only)
      ├─ harness              Ctrl+o leader only
      └─ TUI                  own keys
```

- Rule: hosts never bind raw `Ctrl+<letter>`; only `leader+key` / `prefix+key`.
- Cross-program chords (e.g. `Ctrl+hjkl`) need ONE dispatcher; none active now
  (vim-tmux-navigator removed).
- A chord not dispatched is program-local → it is NOT a global binding.
- Program-local is not a collision: the same chord may mean different things in
  different programs.
- Accepted shadowing: host leader `Ctrl+a` / `Ctrl+b` hide the shell readline
  bindings for those two letters (by design).

## 4. Modifier ownership (reserved blocks)

| Block                                   | Owner (layer)                         | Notes                                                         |
| --------------------------------------- | ------------------------------------- | ------------------------------------------------------------- |
| `Cmd-*`                                 | L0 system + L2 terminal emulator      | always-active system chords win; app chords only when focused |
| `Opt-*`                                 | L1 window manager (skhd/yabai)        | always active; desktops, focus, move, layout                  |
| `Ctrl-*`                                | innermost focused in-terminal program | crowded; **no new global Ctrl bindings**                      |
| `Ctrl+Opt-*`, `Ctrl+Cmd-*`, `Cmd+Opt-*` | FREE                                  | preferred space for new chords                                |

- Never steal `Ctrl+a`, `Ctrl+b` (leaders) or `Ctrl+o` (harness).
- TUIs are free otherwise, subject to the two bullets above.

## 5. Leader keys (sequence: press leader, then key)

| Layer        | Tool             | Leader              | Source                                                |
| ------------ | ---------------- | ------------------- | ----------------------------------------------------- |
| mux          | wezterm (mux)    | `Ctrl+a`            | `wezterm/.wezterm.lua`                                 |
| orchestrator | herdr            | `Ctrl+b`            | `~/.config/herdr/config.toml`                         |
| harness      | opencode / codex | `Ctrl+o`            | `opencode/.config/opencode/cli.json`                  |
| editor       | nvim             | `Space` (local `\`) | `nvim/.config/nvim/lua/config/keymaps.lua`            |

## 6. Hard-reserved chords (do not reuse)

- `Cmd` only → system (e.g. `Cmd+Space`, `Cmd+Tab`, `Cmd+Q/W/M`).
- `Opt` + `hjkl` / `Opt+Shift` / `Opt+b` / `Opt+e s v` / `Opt+w f` → yabai,
  always active.
- `Ctrl+a` → mux leader. `Ctrl+b` → orchestrator leader. `Ctrl+o` → harness
  leader.
- `Ctrl+Shift+n/v/c/+/-/0` → wezterm (fullscreen, paste, copy, font).
- shell/readline (program-local): `Ctrl+p/n` history, `Ctrl+r` search, `Ctrl+l`
  clear, `Ctrl+u/w`, `Ctrl+c/d/z`. (`Ctrl+a/e` not needed → Home/End.)
- nvim: `Space`/`\` leaders, `Ctrl+hjkl` window nav (**normal mode only**),
  `Ctrl+\ Ctrl+n` leave terminal mode.

## 7. Conflict vs collision (the rule)

- **Conflict** = same chord, layers never focused together (e.g. nvim vs another
  editor). Allowed; document it.
- **Collision** = same chord, layers can be active at once. Forbidden; fix by
  leader or free block.
- Never co-focused → never a collision: shell vs TUI/harness (zsh `Ctrl+o` vs
  harness `Ctrl+o`).
- When layers nest (herdr→harness→nvim), only the innermost-focused layer gets
  the raw chord.

## 8. Add / change a binding

1. Pick the layer (L0–L7) or the in-terminal program.
2. Pick the block: L0→`Cmd`, L1→`Opt`, else prefer leader or FREE blocks.
3. Check §5–§6: no `Ctrl+a` / `Ctrl+b` / `Ctrl+o` theft, no always-active or
   shell chord reuse.
4. If the chord must span programs, register it with the one dispatcher, not in
   each program.
5. Apply: L0/L1 → `skhd/.skhdrc` / `yabai/.yabairc`; others → that layer's
   config.
6. If it is a leader or reserved chord, update §5–§6 here.
7. New global chord (L0/L1) must be registered in the WM/system config first.
8. Adding a tool to the stack → add it to "Current stack" and run this review.

## 9. Known conflicts / collisions (to resolve)

- nvim `Ctrl+hjkl` / `Ctrl+\` / `Ctrl+l`: accepted as-is.
- `Ctrl+o` overlap (harness leader / zsh `clear`): accepted workaround; nvim
  terminal in/out uses `<Esc><Esc>`.
- Parked (re-check on reintroduction): tmux, zellij `Ctrl+o` / `Ctrl+a` / `Ctrl+b`.
- herdr config is not stowed yet (lives in `~/.config/herdr/`).

## 10. Sources of truth

| Layer                | Config                                                  |
| -------------------- | ------------------------------------------------------- |
| L0 system            | macOS System Settings (not in repo)                     |
| L1 WM                | `skhd/.skhdrc`, `yabai/.yabairc`                        |
| L2 terminal emulator | `wezterm/.wezterm.lua`, `wezterm/.config/wezterm/*.lua` |
| L3 mux               | `wezterm/.wezterm.lua` (tmux parked)                    |
| L4 orchestrator      | `~/.config/herdr/config.toml`                           |
| L5 harness           | `opencode/.config/opencode/cli.json`                    |
| L6 editor            | `nvim/.config/nvim/lua/config/keymaps.lua`              |
| shell / readline     | `zsh/.zshrc`                                            |

## 11. Answering a keybinding question

1. Walk L0→L7.
2. Report the first layer that claims the chord and its config path.
3. If the chord is `Ctrl+<letter>`, report the focused in-terminal program
   instead (§3).
4. If >1 layer claims it: label conflict or collision (§7).
