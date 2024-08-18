return {
  -- LSP keymaps
  -- https://www.lazyvim.org/plugins/lsp#%EF%B8%8F-customizing-lsp-keymaps
  -- https://www.lazyvim.org/configuration/keymaps#lsp-keymaps
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- change a keymap
      keys[#keys + 1] = {
        "<leader>.",
        vim.lsp.buf.code_action,
        desc = "Code Action",
        mode = { "n", "v" },
        has = "codeAction",
      }
    end,
  },
}
