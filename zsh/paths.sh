addToPathFront $HOME/.local/scripts
addToPathFront $HOME/.local/bin
addToPathFront $HOME/.config/tmux/plugins/tmuxifier/bin
addToPathFront /opt/homebrew/opt/postgresql@16/bin

export PYTHONPATH="${PYTHONPATH}:${HOME}/.local/scripts"
#
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# uv and uvx completions
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"


# TODO: work pc has its own path
