# Directory Finder

A small rust cli to discover directories.

Walks each search path (relative to `$HOME` unless absolute) up to `--depth`,
classifying every directory it finds:

| tag    | shape                                                     |
| ------ | --------------------------------------------------------- |
| `git`  | a normal repository / primary clone                       |
| `bare` | a bare repository (git storage, no working tree)          |
| `sub`  | a submodule (working tree with a superproject above it)   |
| `wt`   | a linked worktree (git dir separate from the common dir)  |
| `dir`  | a plain directory                                         |

Linked worktrees are discovered from every repo found (not just bare ones),
and prunable / missing worktrees are skipped.

## Output

Default (stable, one row per directory):

```txt
(<tag>)	<absolute path>
```

With `--ids`, a session id is added as the middle column:

```txt
(<tag>)	<id>	<absolute path>
```

The id collects the hierarchy (see `docs/session-model.md` §5):

- worktree → `<repo>@<ref>` (short SHA when detached)
- submodule → path relative to the search root
- repo / plain dir → path relative to the search root
- bare → normalized basename (`python-core.git` → `python-core-git`)

Ids are lowercased, collisions are disambiguated (root prefix, then `~<hash>`),
and ids longer than 64 chars are truncated with a hash suffix.

## TODO

- [x] Worktrees and submodules are listed
- [ ] Make it more general using options (configurable roots / depth)
