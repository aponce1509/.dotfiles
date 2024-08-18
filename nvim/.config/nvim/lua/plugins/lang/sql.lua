if lazyvim_docs then
  -- The setup below will automatically configure connections without the need for manual input each time.

  -- Example configuration using dictionary with keys:
  --    vim.g.dbs = {
  --      dev = "Replace with your database connection URL.",
  --      staging = "Replace with your database connection URL.",
  --    }
  -- or
  -- Example configuration using a list of dictionaries:
  --    vim.g.dbs = {
  --      { name = "dev", url = "Replace with your database connection URL." },
  --      { name = "staging", url = "Replace with your database connection URL." },
  --    }

  -- or
  -- Create a `.lazy.lua` file in your project and set your connections like this:
  -- ```lua
  --    vim.g.dbs = {...}
  --
  --    return {}
  -- ```

  -- Alternatively, you can also use other methods to inject your environment variables.

  -- Finally, please make sure to add `.lazy.lua` to your `.gitignore` file to protect your secrets.
end

local sql_ft = { "sql", "mysql", "plsql" }

return {

  {
    "kristijanhusak/vim-dadbod-ui",
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    dependencies = "vim-dadbod",
    keys = {
      { "<leader>D", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
    },
    init = function()
      local data_path = vim.fn.stdpath("data")

      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_save_location = data_path .. "/dadbod_ui"
      vim.g.db_ui_show_database_icon = true
      -- make this configurable using the options
      vim.g.db_ui_save_location = vim.g.sql_path or data_path .. "/dadbod_ui"
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_use_nvim_notify = true

      -- NOTE: The default behavior of auto-execution of queries on save is disabled
      -- this is useful when you have a big query that you don't want to run every time
      -- you save the file running those queries can crash neovim to run use the
      -- default keymap: <leader>S
      vim.g.db_ui_execute_on_save = false
    end,
  },

  {
    "mfussenegger/nvim-lint",
    -- remove dialect
    opts = function(_, opts)
      local lint = require("lint")
      lint.linters.sqlfluff.args = {
        "lint", "--format=json",
        -- note: users will have to replace the --dialect argument accordingly
        -- "--dialect=ansi",
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    -- remove dialect
    opts = function(_, opts)
      opts.formatters.sqlfluff = {
        args = { "format", "-" },
      }
      for _, ft in ipairs(sql_ft) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], "sqlfluff")
      end
    end,
  },
}
