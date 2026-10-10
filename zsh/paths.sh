addToPath() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$PATH:$1
    fi
}

addToPathFront() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$1:$PATH
    fi
}

addToPathFront "$HOME/.local/scripts"
addToPathFront "$HOME/.local/bin"
addToPathFront "$HOME/.config/tmux/plugins/tmuxifier/bin"
addToPathFront /opt/homebrew/opt/postgresql@16/bin
addToPathFront "$HOME/.codeium/windsurf/bin"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# python
export PYTHONPATH="${PYTHONPATH}:${HOME}/.local/scripts"

# TODO: work pc has its own path
