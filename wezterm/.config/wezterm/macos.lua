local M = {}

M.launch_menu = {
  {
    label = 'Zsh',
    args = { 'zsh', '-l' },
  },
  {
    label = "PowerShell",
    args = { 'pwsh' },
  },
  {
    label = "Bash",
    args = { 'bash', '-l' },
  }
}

return M
