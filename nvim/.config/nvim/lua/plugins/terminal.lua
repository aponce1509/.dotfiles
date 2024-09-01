-- local Terminal = require('toggleterm.terminal').Terminal

return {
  {
    "akinsho/toggleterm.nvim",
    cmd = {
      "TermSelect", "ToggleTermSendCurrentLine", "ToggleTermSendVisualLines",
      "ToggleTermSendVisualSelection", "TermExec",
      "ToggleTermToggleAll", "ToggleTerm",
    },
    keys = {
      -- { "<esc><esc>",      "<c-\\><c-n>",                                    desc = "Enter Normal Mode",             mode = "t" },
      { "<leader>fs",      ":TermSelect<CR>",                                desc = "Select a hidden Terminal",      mode = "n" },
      { "<C-\\>",          ":ToggleTerm direction=float name=base<CR>",      desc = "Open base floating terminal",   mode = "n" },
      { "<leader>ft",      ":ToggleTerm direction=float name=base<CR>",      desc = "Open base floating terminal",   mode = "n" },
      { "<localleader>ts", ":ToggleTerm direction=horizontal name=base<CR>", desc = "Open base horizontal terminal", mode = "n" },
      { "<localleader>tv", ":ToggleTerm direction=vertical name=base<CR>",   desc = "Open base vertical terminal",   mode = "n" },
      { "<C-h>",           "<cmd>wincmd h<cr>",                              desc = "Go to Left Window",             mode = "t" },
      { "<C-j>",           "<cmd>wincmd j<cr>",                              desc = "Go to Lower Window",            mode = "t" },
      { "<C-k>",           "<cmd>wincmd k<cr>",                              desc = "Go to Upper Window",            mode = "t" },
      { "<C-l>",           "<cmd>wincmd l<cr>",                              desc = "Go to Right Window",            mode = "t" },
      { "<C-\\>",          "<cmd>close<cr>",                                 desc = "Hide Terminal",                 mode = "t" },

    },
    config = function()
      require("toggleterm").setup {
        -- size can be a number or function which is passed the current terminal
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<c-_>]], -- or { [[<c-\>]], [[<c-¥>]] } if you also use a Japanese keyboard.
        -- on_create = fun(t: Terminal), -- function to run when the terminal is first created
        -- on_open = fun(t: Terminal), -- function to run when the terminal opens
        -- on_close = fun(t: Terminal), -- function to run when the terminal closes
        -- on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
        -- on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
        -- on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
        -- hide_numbers = true, -- hide the number column in toggleterm buffers
        -- shade_filetypes = {},
        -- autochdir = false, -- when neovim changes it current directory the terminal will change it's own when next it's opened
        -- highlights = {
        --   -- highlights which map to a highlight group name and a table of it's values
        --   -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
        --   Normal = {
        --     guibg = "<VALUE-HERE>",
        --   },
        --   NormalFloat = {
        --     link = 'Normal'
        --   },
        --   FloatBorder = {
        --     guifg = "<VALUE-HERE>",
        --     guibg = "<VALUE-HERE>",
        --   },
        -- },
        -- shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
        -- shading_factor = '<number>', -- the percentage by which to lighten dark terminal background, default: -30
        -- shading_ratio = '<number>', -- the ratio of shading factor for light/dark terminal background, default: -3
        -- start_in_insert = true,
        -- insert_mappings = true, -- whether or not the open mapping applies in insert mode
        -- terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
        -- persist_size = true,
        -- persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
        -- direction = 'vertical' | 'horizontal' | 'tab' | 'float',
        -- close_on_exit = true, -- close the terminal window when the process exits
        --  -- Change the default shell. Can be a string or a function returning a string
        -- shell = vim.o.shell,
        -- auto_scroll = true, -- automatically scroll to the bottom on terminal output
        -- -- This field is only releva <value>nt if direction is set to 'float'
        float_opts = {
          -- The border key is *almost* the same as 'nvim_open_win'
          -- see :h nvim_open_win for details on borders however
          -- the 'curved' border is a custom border type
          -- not natively supported but implemented in this plugin.
          -- border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
          -- like `size`, width, height, row, and col can be a number or function which is passed the current terminal
          width = function()
            return math.floor(vim.o.columns * 0.7)
          end,
          height = function()
            return math.floor(vim.o.lines * 0.5)
          end,
          -- row = 20,
          -- col = 20,
          --   winblend = 3,
          --   zindex = <value>,
          --   title_pos = 'left' | 'center' | 'right', position of the title of the floating window
          border = 'curved'
        }
        -- winbar = {
        --   enabled = false,
        --   name_formatter = function(term) --  term: Terminal
        --     return term.name
        --   end
        -- },
      }
    end,
    lazy = false,
  }
}
