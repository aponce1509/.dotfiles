return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = { tex = { "tex-fmt" } }
    end,
  },
  { "jbyuki/nabla.nvim" },
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      servers = {
        texlab = {
          filetypes = { "tex", "latex", "markdown", "md" },
          keys = {
            { "<Leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex Docs", silent = true },
          },
        },
      },
    },
  }
  -- {
  --   "mfussenegger/nvim-lint",
  --   optional = true,
  --   opts = {
  --     linters_by_ft = {
  --       tex = { "chktex", "lacheck" },
  --     },
  --   },
  -- }
}
