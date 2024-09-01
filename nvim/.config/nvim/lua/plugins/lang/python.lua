return {
  -- Additional Plug-ins
  -- LazyVim Plug-ins
  { "linux-cultist/venv-selector.nvim", enabled = false },
  -- Mason dependencies
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "black", "mypy"
      })
    end,
  },
  -- treesitter dependencies
  -- Linting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "mypy" },
      },
      linters = {
        mypy = {
          -- TODO: ARGS do not work, so you are force to mypy.ini / pyproject.toml file
          -- This works because of the autoselection of venv
          -- Looks that mypy installed by mason can use the env packages though
          cmd = "mypy",
          -- args = { "--strict" }
          -- args = function()
          --   local virtual = os.getenv "CONDA_PREFIX" or os.getenv "VIRTUAL_ENV" or "/usr"
          --   return { "--stricta", "--python-executable", virtual .. "/bin/python" }
          -- end,

        }
      }
    }
  },
  -- mini.ai for jupyter cells
  {
    "echasnovski/mini.ai",
    opts = function(_, opts)
      opts.custom_textobjects["C"] = function(ai_type)
        local line_num = vim.fn.line('.')
        local first_line = 1
        local last_line = vim.fn.line('$')
        local line = vim.fn.getline(line_num)
        local cond = function(l)
          if l:len() > 3 then
            if l:sub(1, 4) == '# %%' then
              return true
            end
          end
          return false
        end
        local found_up = true

        -- Find first line in cell
        while not cond(line) do
          line_num = line_num - 1
          line = vim.fn.getline(line_num)
          if line_num == 1 then
            found_up = false
            break
          end
        end

        if not found_up then
          print("hola")
          local cur_pos = vim.api.nvim_win_get_cursor(0)
          return {
            from = { line = cur_pos[1], col = cur_pos[2] + 1 }
          }
        end

        -- If inside, not include cell delimiter
        if ai_type == 'i' then
          first_line = line_num + 1
        else
          first_line = line_num
        end

        -- Find last line in cell
        line_num = vim.fn.line('.')
        line = vim.fn.getline(line_num)
        local found_down = true
        while not cond(line) do
          if line_num == last_line then
            found_down = false
            break
          end
          line_num = line_num + 1
          line = vim.fn.getline(line_num)
        end
        local last_col = line:len()
        if found_down then
          last_line = line_num - 1
          line = vim.fn.getline(last_line)
          last_col = math.max(line:len(), 1)
        else
          last_col = math.max(last_col, 1)
        end
        return { from = { line = first_line, col = 1 }, to = { line = last_line, col = last_col } }
      end
    end,
  },
  -- Formatting
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = { python = { "black" } }
    end,
  },
  {
    "geg2102/nvim-python-repl",
    dependencies = { "nvim-treesitter", "mini.ai" },
    ft = { "python", "lua", "scala" },
    opts = {
      execute_on_send = true,
      vsplit = true,
    },
    keys = {
      { "<leader>nj",   function() require('nvim-python-repl').send_statement_definition() end, desc = "Send semantic unit to REPL" },
      { "<leader><CR>", function() require('nvim-python-repl').send_visual_to_repl() end,       desc = "Send visual selection to REPL",                   mode = "v" },
      { "<leader>nf",   function() require('nvim-python-repl').send_buffer_to_repl() end,       desc = "Send entire buffer to REPL" },
      { "<leader>ne",   function() require('nvim-python-repl').toggle_execute() end,            desc = "Automatically execute command in REPL after sent" },
      { "<leader>nv",   function() require('nvim-python-repl').toggle_vertical() end,           desc = "Create REPL in vertical or horizontal split" },
      { "<leader>nk",   function() require('nvim-python-repl').open_repl() end,                 desc = "Opens the REPL in a window split" },
    },
  },
}
