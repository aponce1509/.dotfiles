# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "aponce"; then
  new_window "main"
  new_window "notes"
  run_cmd "cd /Users/aponce1509/repos/new_second_brain/"
  run_cmd "clear"
  run_cmd "nvim '00 - Start Here.md'"
  select_pane 0
  new_window "todo"
  run_cmd "cd /Users/aponce1509/repos/new_second_brain/"
  run_cmd "nvim todo.md"
  split_h
  # run_cmd "cd /Users/aponce1509/repos/new_second_brain/"
  # run_cmd "clear"
  # run_cmd "nvim './07 - Daily/_sites.md'"
  # split_h 33
  run_cmd "cd /Users/aponce1509/repos/new_second_brain/"
  run_cmd "clear"
  run_cmd "nvim './07 - Daily/_day.md'"
  select_pane 0

  select_window "main"

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
