# todo-keys.md

- Gaps found while reviewing `AGENTS.md`. Not active bindings yet.
- Resolve a gap → apply it → move the item to `AGENTS.md`.

## Decisions locked

- [x] `Ctrl+p` / `Ctrl+n` → shell-reserved (readline history); program-local.
- [x] Pane nav: keep `Ctrl+hjkl` (do not move it to another key).
- [x] `Ctrl+\` → harness leader; nvim float toggle moved to `Ctrl+;`.
- [x] Shell vs TUI/harness are never co-focused → shared chords are conflicts,
      not collisions (they share chords freely).
- [x] `Ctrl+o` overlap resolved: harness leader moved to `Ctrl+\`, so `Ctrl+o`
      returns to the shell (`clear`). nvim terminal in/out uses `<Esc><Esc>`.
- [x] skhd float layout → `alt - v` (was colliding with focus east on `alt - l`).
- [x] Dropped vim-tmux-navigator (nvim plugin + tmux plugin line); `Ctrl+hjkl`
      now comes from `keymaps.lua` only.
- [x] herdr stowed (`herdr/.config/herdr/config.toml`); prefix pinned `ctrl+b`;
      server reloaded clean.

## Policy to define

- [ ] Home/End own line-start/end → `Ctrl+a/e` not needed in shell
- [ ] program-local vs global: `Ctrl+<letter>` is local unless a dispatcher routes it
- [ ] shell-reserved set: `Ctrl+p/n`, `Ctrl+r`, `Ctrl+u/w`, `Ctrl+c/d/z`

## Stack hygiene

- [ ] tmux + zellij parked; re-map `Ctrl+o` / `Ctrl+a` / `Ctrl+b` on reintroduction
- [ ] project manager (session manager): `^f` (`tmux-sessioner`) and `^g`
      (`tmuxifier-session`) dropped while tmux is parked; choose a replacement and
      a free chord (or a leader)
- [ ] `AGENTS.md`: keep "current stack" section in sync
- [ ] Rule: adding any tool to the stack requires a conflict review
