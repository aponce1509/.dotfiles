local M = {}

M.launch_menu = {
  {
    label = "PowerShell",
    args = { 'powershell' },
  },
  {
    label = 'Git Bash',
    args = { 'zsh', '-l' },
  },
  {
    label = "CMDer Bash",
    args = { 'zsh', '-l' },
  }
}

return M
