# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/.dotfiles"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "dotfiles"; then
  new_window "nvim"
  run_cmd "source ~/.zshrc"
  run_cmd "clear"
  run_cmd "nvim"
  new_window "terminal"
  select_window "terminal"
  run_cmd "source ~/.zshrc"
  run_cmd "clear"
  # run_cmd 'source ~/.local/scripts/python_venv_activate'
  # run_cmd 'CONDA_BIN_PATH="$(conda info --base)/envs/$(basename $CONDA_DEFAULT_ENV)/bin"'
  # run_cmd 'PATH=$CONDA_BIN_PATH:$PATH'
fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
