# rust

Small Rust utilities that ship with the dotfiles. One Cargo **workspace** so
utilities share a dependency set and a single `target/`.

## Layout

```txt
rust/
├─ Cargo.toml            workspace root (members + shared dependency versions)
├─ Cargo.lock
├─ install               build + install (macOS / Linux)
├─ install.ps1           build + install (Windows)
└─ directory_finder/     first utility
   ├─ Cargo.toml
   ├─ README.md
   └─ src/main.rs
```

## Utilities

| Crate              | Binary             | Purpose                                                |
| ------------------ | ------------------ | ------------------------------------------------------ |
| `directory_finder` | `directory_finder` | Discover repos, bare repos, submodules and worktrees on disk. |

## Add a utility

```sh
cd rust
cargo new --bin my_tool
```

Then add `"my_tool"` to `members` in `rust/Cargo.toml`. To reuse a pinned
dependency, add it to `[workspace.dependencies]` and reference it with
`my_tool = { workspace = true }` in the crate manifest.

## Build + install

Installs every binary crate into `~/.local/bin` (already on PATH via
`zsh/paths.sh`). Override the root with `RUST_INSTALL_ROOT`.

```sh
./rust/install
```

```powershell
.\rust\install.ps1
```

Only crates with a binary target (`src/main.rs` or a `[[bin]]` table) are
installed; helper library crates are skipped.
