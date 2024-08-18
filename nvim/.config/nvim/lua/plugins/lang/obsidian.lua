return {
  {
    "epwalsh/obsidian.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    lazy = false,
    version = "*",
    keys = {
      {
        "<leader>jk",
        function()
          local file_lister = require("bin.file_lister")
          local root = "/Users/aponce1509/OneDrive/Documents/2_areas/SecondBrain/"
          local folder = "00 - Map of Contents"
          file_lister.show_list_files(root, folder) -- prompt_title will default to "00 - Map of Contents"
        end,
        desc = "List all the Indexes"
      },
      {
        "<leader>jd",
        "<cmd>vsplit ~/OneDrive/Documents/2_areas/SecondBrain/Todo.md<CR>:vertical resize 65%<CR>",
        desc = "Open todo.md in a vertically split window"
      },

      { "<leader>jn", "<cmd> ObsidianNew <CR>",    desc = "Obsidian New File" },
      { "<leader>jo", "<cmd> ObsidianSearch <CR>", desc = "Obsidian Search files" },
      {
        "<leader>je",
        "<cmd> ObsidianOpen <CR>",
        desc = "Obsidian Open External (obsidian App)"
      },
      {
        "<leader>jb",
        "<cmd> ObsidianBacklinks <CR>",
        desc = "Obsidian list backlinks"
      },
      { "<leader>jt", "<cmd> ObsidianTags <CR>", desc = "Obsidian list all tags" },
      {
        "<leader>jjn",
        "<cmd> ObsidianToday <CR>",
        desc = "Obsidian open today note"
      },
      {
        "<leader>jjy",
        "<cmd> ObsidianYesterday <CR>",
        desc = "Obsidian open yesterday note"
      },
      {
        "<leader>jjt",
        "<cmd> ObsidianTomorrow <CR>",
        desc = "Obsidian open tomorow note"
      },
      {
        "<leader>jjj",
        "<cmd> ObsidianDailies <CR>",
        desc = "Obsidian open journal picker"
      },
      {
        "<leader>jm",
        "<cmd> ObsidianTemplates <CR>",
        desc = "Obsidian Insert Template"
      },
      {
        "<leader>ji",
        "<cmd> ObsidianPasteImg <CR>",
        desc = "Obsidian Paste Image from clipboard"
      },
      {
        "<leader>jl",
        "<cmd> ObsidianLink <CR>",
        desc = "Obsidian select Link and insert in cursor"
      },
      {
        "<leader>jr",
        "<cmd> ObsidianExtractNote <CR>",
        desc = "Obsidian extract selected to new note",
        mode = { "v" },
      },
      {
        "<leader>jl",
        "<cmd> ObsidianLinkNew <CR>",
        desc = "Obsidian Create new link from selected text",
        mode = { "v" },
      },
    },
    opts = function()
      local is_windows = package.config:sub(1, 1) == '\\'

      -- Define the variable based on the OS
      local second_brain_path

      if is_windows then
        -- Retrieve the environment variable for Windows
        second_brain_path = os.getenv("PERSONAL_SECOND_BRAIN")
      else
        -- Retrieve the environment variable for macOS
        second_brain_path = os.getenv("WORK_SECOND_BRAIN")
      end
      return {
        workspaces = {
          {
            name = "personal",
            path = second_brain_path,
          },
        },
        completion = {
          nvim_cmp = true,
          min_chars = 2,
        },
        new_notes_location = "notes_subdir",
        notes_subdir = "09 - Inbox",
        daily_notes = {
          -- Optional, if you keep daily notes in a separate directory.
          folder = "07 - Daily",
          -- Optional, if you want to change the date format for the ID of daily notes.
          date_format = "%Y-%m-%d",
          -- Optional, if you want to change the date format of the default alias of daily notes.
          alias_format = "%B %-d, %Y",
          -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
          template = second_brain_path .. "/99 - Meta/Templates/Nvim/daily.md",
        },
        wiki_link_func = function(opts)
          if opts.id == nil then
            return string.format("[[%s]]", opts.label)
          elseif opts.label ~= opts.id then
            return string.format("[[%s|%s]]", opts.id, opts.label)
          else
            return string.format("[[%s]]", opts.id)
          end
        end,

        -- mappings = {
        --   -- "Obsidian follow"
        --   ["<leader>of"] = {
        --     action = function()
        --       return require("obsidian").util.gf_passthrough()
        --     end,
        --     opts = { noremap = false, expr = true, buffer = true },
        --   },
        --   -- Toggle check-boxes "obsidian done"
        --   ["<leader>od"] = {
        --     action = function()
        --       return require("obsidian").util.toggle_checkbox()
        --     end,
        --     opts = { buffer = true },
        --   },
        --   -- Create a new newsletter issue
        --   ["<leader>onn"] = {
        --     action = function()
        --       return require("obsidian").commands.new_note("Newsletter-Issue")
        --     end,
        --     opts = { buffer = true },
        --   },
        --   ["<leader>ont"] = {
        --     action = function()
        --       return require("obsidian").util.insert_template("Newsletter-Issue")
        --     end,
        --     opts = { buffer = true },
        --   },
        -- },
        -- Specify how to handle attachments.
        attachments = {
          -- The default folder to place images in via `:ObsidianPasteImg`.
          -- If this is a relative path it will be interpreted as relative to the vault root.
          -- You can always override this per image by passing a full path to the command instead of just a filename.
          img_folder = "99 - Meta/Attachments", -- This is the default
          -- A function that determines the text to insert in the note when pasting an image.
          -- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
          -- This is the default implementation.
          img_text_func = function(client, path)
            path = client:vault_relative_path(path) or path
            return string.format("![[%s]]", path.name)
          end,
        },
        note_frontmatter_func = function(note)
          -- This is equivalent to the default frontmatter function.
          local out = {}
          -- `note.metadata` contains any manually added fields in the frontmatter.
          -- So here we just make sure those fields are kept in the frontmatter.
          if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
            for k, v in pairs(note.metadata) do
              out[k] = v
            end
          end
          return out
        end,

        note_id_func = function(title)
          -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
          -- In this case a note with the title 'My new note' will be given an ID that looks
          -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
          local suffix = ""
          if title ~= nil then
            -- If title is given, transform it into valid file name.
            suffix = title
          else
            -- If title is nil, just add 4 random uppercase letters to the suffix.
            suffix = "Untitled - " .. suffix
            for _ = 1, 10 do
              suffix = suffix .. string.char(math.random(65, 90))
            end
          end
          return suffix
        end,

        templates = {
          subdir = "99 - Meta/Templates/Nvim",
          date_format = "%Y-%m-%d-%a",
          time_format = "%H:%M",
          tags = "",
          substitutions = {
            daily_tasks_minus_3 = function()
              return os.date("%Y-%m-%d", os.time() - 3 * 24 * 60 * 60)
            end,
            daily_tasks_plus_2 = function()
              return os.date("%Y-%m-%d", os.time() + 2 * 24 * 60 * 60)
            end,
          },
        },
      }
    end,
    cmd = {
      "ObsidianOpen",
      "ObsidianNew",
      "ObsidianQuickSwitch",
      "ObsidianFollowLink",
      "ObsidianBacklinks",
      "ObsidianTags",
      "ObsidianToday",
      "ObsidianYesterday",
      "ObsidianTomorrow",
      "ObsidianDailies",
      "ObsidianTemplate",
      "ObsidianSearch",
      "ObsidianLink",
      "ObsidianLinkNew",
      "ObsidianLinks",
      "ObsidianExtractNote",
      "ObsidianWorkspace",
      "ObsidianPasteImg",
      "ObsidianRename",
    },
  },
}
