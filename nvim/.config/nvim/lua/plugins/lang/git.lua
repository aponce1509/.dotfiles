return {
  {
    "tpope/vim-fugitive",
    cmd = "Git",
    keys = {
      { "<leader>gS", "<cmd>Git<CR>",        desc = "Git Fugitive status" },
      { "<leader>ga", "<cmd>Git add %<CR>",  desc = "Git add current file" },
      { "<leader>gc", "<cmd>Git commit<CR>", desc = "Git commit staged files" },
      { "<leader>gp", "<cmd>Git push<CR>",   desc = "Git commit staged files" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    keys = {
      { "<leader>gi", ":Gitsigns preview_hunk<CR>",              desc = "Git Preview Hunk" },
      { "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", desc = "Git blame toggle" },
    },
  },
}
