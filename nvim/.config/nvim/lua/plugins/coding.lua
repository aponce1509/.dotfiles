return {
  -- {
  --   'saghen/blink.compat',
  --   version = '*',
  --   lazy = true,
  --   opts = {},
  -- },
  {
    "christoomey/vim-tmux-navigator",
    cmd = { "NvimTmuxNavigateLeft", "NvimTmuxNavigateRight", "NvimTmuxNavigateDown", "NvimTmuxNavigateUp" },
    keys = {
      { "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>" },
      { "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>" },
      { "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>" },
      { "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>" },
    },
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    opts = {},
  },
  -- {
  --   "saghen/blink.cmp",
  --   opts = {
  --     completion = {
  --       list = { selection = 'manual' },
  --       accept = {
  --         -- experimental auto-brackets support
  --         auto_brackets = {
  --           enabled = false,
  --         },
  --       },
  --     },
  --     -- experimental signature help support
  --     signature = { enabled = false },
  --     keymap = {
  --       preset = "super-tab",
  --       ['<C-l>'] = { 'show', 'show_documentation', 'hide_documentation' },
  --       ['<C-e>'] = { 'hide', 'fallback' },
  --       ['S-<CR>'] = { 'accept', 'fallback' },
  --       ['<CR>'] = { 'select_and_accept', 'fallback' },
  --       ['<Tab>'] = {
  --         function(cmp)
  --           if cmp.snippet_active() then
  --             return cmp.accept()
  --           else
  --             return cmp.select_next()
  --           end
  --         end,
  --         'snippet_forward',
  --         'fallback',
  --       },
  --       ['<S-Tab>'] = {
  --         function(cmp)
  --           if cmp.snippet_active() then
  --             return cmp.snippet_backward()
  --           else
  --             return cmp.select_prev()
  --           end
  --         end,
  --         'snippet_backward',
  --         'fallback',
  --       },
  --
  --       ['<Up>'] = { 'select_prev', 'fallback' },
  --       ['<Down>'] = { 'select_next', 'fallback' },
  --       ['<C-p>'] = { 'select_prev', 'fallback' },
  --       ['<C-n>'] = { 'select_next', 'fallback' },
  --
  --       ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
  --       ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
  --     },
  --   },
  -- },
  {
    -- https://www.lazyvim.org/configuration/recipes#supertab
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      local cmp = require("cmp")
      local auto_select = true
      opts.completion = {
        completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
      }
      opts.preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = LazyVim.cmp.confirm({ select = auto_select }),
        ["<C-y>"] = LazyVim.cmp.confirm({ select = true }),
        -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
        ["<C-CR>"] = function(fallback)
          cmp.abort()
          fallback()
        end,
        -- ["<C-l>"] = LazyVim.cmp.confirm({ select = true }),

        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            -- cmp.confirm({ select = true })
            cmp.select_next_item()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end, { "i", "s" }),

        -- ["<C-j>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
        --     cmp.select_next_item()
        --   elseif vim.snippet.active({ direction = 1 }) then
        --     vim.schedule(function()
        --       vim.snippet.jump(1)
        --     end)
        --   elseif has_words_before() then
        --     cmp.complete()
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
        --
        -- ["<C-k>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_prev_item()
        --   elseif vim.snippet.active({ direction = -1 }) then
        --     vim.schedule(function()
        --       vim.snippet.jump(-1)
        --     end)
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
      })
    end,
  },
}
