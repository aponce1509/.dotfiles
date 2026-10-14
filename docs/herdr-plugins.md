# Herdr plugins

**Status: manual.** Plugins are installed by hand; the dotfiles neither install
nor sync them yet. This is the record of what's installed (and planned) and the
TODO list for making it reproducible later.

Why it isn't stowed today:

- Herdr has **no declarative plugin list**. `config.toml` can only bind keys to a
  plugin action (`[[keys.command]]` with `type = "plugin_action"`); it cannot
  install a plugin.
- Installed plugins are registered in `~/.config/herdr/plugins.json`
  (`plugins.json` here is machine-specific: it stores absolute `managed_path`
  values), so the registry can't be stowed as-is.
- The only install path is `herdr plugin install <owner/repo[/subdir]>`
  (GitHub shorthand only), optionally pinned with `--ref`.

See [AGENTS.md → §10 Sources of truth](../AGENTS.md) for the layer this belongs
to (L4 orchestrator).

## Installed (manual)

| Plugin              | Source                  | Pin                                  | Version        | Installed  | Purpose                                                                       |
| ------------------- | ----------------------- | ------------------------------------ | -------------- | ---------- | ----------------------------------------------------------------------------- |
| `devswha.herdr-web-ui` | `github:devswha/herdr-web-ui` | `f704740ef1b70c876d0f1647c6e38354aa09ce4e` | `0.4.7` (`min_herdr 0.9.0`) | 2026-10-11 | Browser/phone client for herdr: chat + live terminal for every agent pane, remote PCs over SSH, web push alerts |

Install / operate:

```sh
herdr plugin install devswha/herdr-web-ui --ref f704740   # reinstall refreshes the checkout
herdr plugin action invoke devswha.herdr-web-ui.start     # leaves a running server alone
herdr plugin action invoke devswha.herdr-web-ui.status
herdr plugin action invoke devswha.herdr-web-ui.phone     # phone-setup pane
herdr plugin action invoke devswha.herdr-web-ui.stop
herdr plugin uninstall devswha.herdr-web-ui
```

State and secrets (not in the repo, not synced):

- Plugin config dir (`herdr plugin config-dir devswha.herdr-web-ui`) →
  `~/.config/herdr/plugins/config/devswha.herdr-web-ui` (holds the `env` file).
- Push keys and paired devices → `~/.config/herdr-web-ui`.
- Plugin-owned runtime state → `HERDR_PLUGIN_STATE_DIR`.

## To install (planned, manual)

Not installed yet — recorded here so the list stays complete.

| Plugin                 | Source                        | Pin    | Version | Min herdr | Platforms          | Purpose                                                                     |
| ---------------------- | ----------------------------- | ------ | ------- | --------- | ------------------ | --------------------------------------------------------------------------- |
| `herdr-agent-grid`     | `github:jeffarese/herdr-agent-grid` | none (latest) | `2.0.2` | `0.9.0`   | `linux`, `macos`   | One-command center for every agent's live status, tools, messages and API cost; opens a `grid` popup pane from the `open` action (context `global`) |

Install (no ref pin, as requested):

```sh
herdr plugin install jeffarese/herdr-agent-grid
herdr plugin action invoke herdr-agent-grid.open
```

Note: the plugin's own `install.sh` additionally inserts `Cmd+G`, `prefix+a`
and `Ctrl+Alt+G` shortcuts. Per AGENTS.md §4–§6, `Cmd-*` belongs to the
system/terminal, so if we add a binding ourselves prefer `prefix+a` (or another
free `prefix+…`) rather than the `Cmd`/`Ctrl+Alt` ones.

## TODO — make it synced

- [ ] Add a `herdr/install` (macOS/Linux) + `herdr/install.ps1` (Windows)
      bootstrap that runs the pinned `herdr plugin install` for every plugin
      listed above, guarded by `command -v herdr`, and wire it into the `macos`
      bootstrap (same shape as `rust/install`).
- [ ] Install `jeffarese/herdr-agent-grid` by hand for now and confirm
      `herdr-agent-grid.open` opens the grid pane.
- [ ] Decide the pin policy: exact `--ref <commit>` (reproducible) vs. latest
      release tag (auto-updates). Today it's mixed: `devswha/web-ui` pinned to a
      commit, `agent-grid` unpinned.
- [ ] Bind the plugin actions in `herdr/.config/herdr/config.toml` via
      `[[keys.command]]` (`type = "plugin_action"`). Follow AGENTS.md §8: leader
      `Ctrl+b`, no reserved/always-active chord theft. Candidate: `prefix+s`
      (status/start).
- [ ] Decide whether to sync the plugin **config dir** from the repo. Rule:
      never commit tokens; if synced, template the `env` file and keep secrets
      out of git.
- [ ] If this becomes part of the stack bootstrap, note the plugin in
      AGENTS.md §10 "Sources of truth".

## Sources

- Herdr plugins doc: <https://herdr.dev/docs/plugins/>
- Plugin repo: <https://github.com/devswha/herdr-web-ui>
- Plugin repo: <https://github.com/jeffarese/herdr-agent-grid>
