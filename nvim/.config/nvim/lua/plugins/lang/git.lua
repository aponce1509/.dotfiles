return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>P", group = "hunks" },
        },
      },
    },

  },
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
      { "<leader>gn", ":Gitsigns preview_hunk<CR>",                                       desc = "Git Preview Hunk" },
      { "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>",                          desc = "Git blame toggle" },
      { "<leader>Ps", ":Gitsigns stage_hunk<CR>",                                         desc = "Stage Hunk",         mode = { "n", "v" } },
      { "<leader>Pr", ":Gitsigns reset_hunk<CR>",                                         desc = "Reset Hunk",         mode = { "n", "v" } },
      { "<leader>PS", function() package.loaded.gitsigns.stage_buffer() end,              desc = "Stage Buffer" },
      { "<leader>Pu", function() package.loaded.gitsigns.undo_stage_hunk() end,           desc = "Undo Stage Hunk" },
      { "<leader>PR", function() package.loaded.gitsigns.reset_buffer() end,              desc = "Reset Buffer" },
      { "<leader>Pp", function() package.loaded.gitsigns.preview_hunk_inline() end,       desc = "Preview Hunk Inline" },
      { "<leader>Pb", function() package.loaded.gitsigns.blame_line({ full = true }) end, desc = "Blame Line" },
      { "<leader>PB", function() package.loaded.gitsigns.blame() end,                     desc = "Blame Buffer" },
      { "<leader>Pd", function() package.loaded.gitsigns.diffthis() end,                  desc = "Diff This" },
      { "<leader>PD", function() package.loaded.gitsigns.diffthis("~") end,               desc = "Diff This ~" },
    },
  },
}
