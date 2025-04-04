return {
  {
    "hkupty/iron.nvim",
    cmd = { "IronRepl", "IronFocus", "IronRepl", "IronHide" },
    keys = {
      { "<space>ns", "<cmd>IronRepl<Cr>",    desc = "(Iron) Open RELP" },
      { "<space>nr", "<cmd>IronRestart<Cr>", desc = "(Iron) Restart RELP" },
      { "<space>nf", "<cmd>IronFocus<Cr>",   desc = "(Iron) focus RELP" },
      { "<space>nh", "<cmd>IronHide<Cr>",    desc = "(Iron) Hide RELP" },
    },
    config = function()
      local iron = require("iron.core")
      local common = require("iron.fts.common")
      iron.setup({
        config = {
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Your repl definitions come here
          repl_definition = {
            sh = {
              -- Can be a table or a function that
              -- returns a table (see below)
              command = { "zsh" },
            },
            python = {
              command = { "ipython", "--no-autoindent" }, -- or { "ipython", "--no-autoindent" }
              format = common.bracketed_paste,
              block_deviders = { "# %%", "#%%" },
            }
          },
          -- How the repl window will be displayed
          -- See below for more information
          repl_open_cmd = require("iron.view").split.vertical.botright("40%"),
        },
        -- Iron doesn't set keymaps by default anymore.
        -- You can set them here or manually add keymaps to the functions in iron.core
        keymaps = {
          send_motion = "<space>nc",
          visual_send = "<space><cr>",
          send_file = "<space>nf",
          send_line = "<space>nj",
          send_mark = "<space>nm",
          mark_motion = "<space>mc",
          mark_visual = "<space>mc",
          remove_mark = "<space>md",
          cr = "<space>n<cr>",
          interrupt = "<space>n<space>",
          exit = "<space>nq",
          clear = "<space>nl",
          send_code_block = "<space><cr>",
          send_code_block_and_move = "<space><s-cr>",
        },
        -- If the highlight is on, you can change how it looks
        -- For the available options, check nvim_set_hl
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
      })

      -- iron also has a list of commands, see :h iron-commands for all available commands
    end,

  },
}
