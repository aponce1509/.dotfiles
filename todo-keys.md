# todo-keys.md

- Gaps found while reviewing `AGENTS.md`. Not active bindings yet.
- Resolve a gap → apply it → move the item to `AGENTS.md`.

## Decisions locked

- [x] `Ctrl+p` / `Ctrl+n` → shell-reserved (readline history); program-local.
- [x] Pane nav: keep `Ctrl+hjkl` (do not move it to another key).
- [x] `Ctrl+\` and `Ctrl+l` accepted as-is (no change).
- [x] Shell vs TUI/harness are never co-focused → shared chords are conflicts,
      not collisions (e.g. zsh `Ctrl+o` vs harness `Ctrl+o`).
- [x] `Ctrl+o` overlap accepted as a workaround (harness leader / zsh `clear`);
      no nvim remap. nvim terminal in/out uses `<Esc><Esc>`.
- [x] skhd float layout → `alt - v` (was colliding with focus east on `alt - l`).
- [x] Dropped vim-tmux-navigator (nvim plugin + tmux plugin line); `Ctrl+hjkl`
      now comes from `keymaps.lua` only.

## Policy to define

- [ ] Home/End own line-start/end → `Ctrl+a/e` not needed in shell
- [ ] program-local vs global: `Ctrl+<letter>` is local unless a dispatcher routes it
- [ ] shell-reserved set: `Ctrl+p/n`, `Ctrl+r`, `Ctrl+u/w`, `Ctrl+c/d/z`

## Stack hygiene

- [ ] tmux + zellij parked; re-map `Ctrl+o` / `Ctrl+a` / `Ctrl+b` on reintroduction
- [ ] `AGENTS.md`: keep "current stack" section in sync
- [ ] Rule: adding any tool to the stack requires a conflict review
