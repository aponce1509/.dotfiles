return {
  {
    "pwntester/octo.nvim",
    keys = {
      { "<leader>On",  "<cmd>Octo issue create<CR>",  desc = "Create a new Issue (Octo)" },
      { "<leader>Oo",  "<cmd>Octo issue browser<CR>", desc = "Open Issue in browser (Octo)" },
      { "<leader>Or",  "<cmd>Octo issue reload<CR>",  desc = "Reload Issue (Octo)" },
      { "<leader>Opn", "<cmd>Octo pr create<CR>",     desc = "Create a new PR (Octo)" },
      { "<leader>Opc", "<cmd>Octo pr commits<CR>",    desc = "List all the PR commits (Octo)" },
      { "<leader>Opd", "<cmd>Octo pr diff<CR>",       desc = "PR Diff (Octo)" },
      { "<leader>Opm", "<cmd>Octo pr merge<CR>",      desc = "PR Merge (Octo)" },
      { "<leader>OpQ", "<cmd>Octo pr close<CR>",      desc = "close PR (Octo)" },
      { "<leader>Ops", "<cmd>Octo review start<CR>",  desc = "Create a new PR (Octo)" },
      { "<leader>Os",  "<cmd>Octo card set <CR>",     desc = "close PR (Octo)" },
    }
  }
}
