return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["markdown"] = { "prettier" },
      },
    },
    keys = {
      {
        "<leader>fm",
        function()
          require("conform").format({ timeout_ms = 3000 })
        end,
        mode = { "n", "v" },
        desc = "Format with conform",
      },
      { "<leader>F", ":silent %!prettier --stdin-filepath %<CR>", desc = "Format with prettier" }
    },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "prettier" } },
  }
}
