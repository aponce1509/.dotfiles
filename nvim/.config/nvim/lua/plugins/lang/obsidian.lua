-- raise a error if the env var is not set
local root_path = os.getenv("SECOND_BRAIN_PATH") or error("SECOND_BRAIN_PATH is not set")
return {
  {
    -- https://github.com/obsidian-nvim/obsidian.nvim
    "obsidian-nvim/obsidian.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    lazy = false,
    version = "*",

    keys = {
      {
        "<leader>jJ",
        function()
          return require("obsidian").util.smart_action()
        end,
        desc = "Smart obsidian action: Todo or follow"
      },
      {
        "<leader>jki",
        function()
          local file_lister = require("bin.file_lister")
          local root = root_path
          local folder = "00 - Map of Contents/00 - Index"
          file_lister.show_list_files(root, folder, 1)
        end,
        desc = "List all the Indexes"
      },
      {
        "<leader>jkr",
        function()
          local file_lister = require("bin.file_lister")
          local root = root_path
          local folder = "03 - Resources"
          file_lister.show_list_files(root, folder, 1)
        end,
        desc = "List all the active Resources"
      },
      {
        "<leader>jkp",
        function()
          local file_lister = require("bin.file_lister")
          local root = root_path
          local folder = "01 - Projects"
          file_lister.show_list_files(root, folder, 1)
        end,
        desc = "List all the active Projects"
      },
      {
        "<leader>jka",
        function()
          local file_lister = require("bin.file_lister")
          local root = root_path
          local folder = "02 - Areas"
          file_lister.show_list_files(root, folder, 1)
        end,
        desc = "List all the active Areas"
      },
      {
        "<leader>jkm",
        function()
          local file_lister = require("bin.file_lister")
          local root = root_path
          local folder = "00 - Map of Contents"
          file_lister.show_list_files(root, folder, 1)
        end,
        desc = "List all the Map of Contents"
      },

      {
        "<leader>jd",
        "<cmd>vsplit" .. root_path .. "Todo.md<CR>:vertical resize 65%<CR>",
        desc = "Open todo.md in a vertically split window"
      },

      { "<leader>jr", "<cmd>Obsidian rename<CR>", desc = "Obsidian Rename Note" },
      { "<leader>jn", "<cmd>Obsidian new<CR>", desc = "Obsidian New File" },
      { "<leader>jo", "<cmd>Obsidian search<CR>", desc = "Obsidian Search files" },
      {
        "<leader>je",
        "<cmd>Obsidian open<CR>",
        desc = "Obsidian Open External (obsidian App)"
      },
      {
        "<leader>jb",
        "<cmd>Obsidian backlinks<CR>",
        desc = "Obsidian list backlinks"
      },
      { "<leader>jt", "<cmd>Obsidian tags<CR>", desc = "Obsidian list all tags" },
      {
        "<leader>jjn",
        "<cmd>Obsidian today<CR>",
        desc = "Obsidian open today note"
      },
      {
        "<leader>jjy",
        "<cmd>Obsidian yesterday<CR>",
        desc = "Obsidian open yesterday note"
      },
      {
        "<leader>jjt",
        "<cmd>Obsidian tomorrow<CR>",
        desc = "Obsidian open tomorow note"
      },
      {
        "<leader>jjj",
        "<cmd>Obsidian dailies<CR>",
        desc = "Obsidian open journal picker"
      },
      {
        "<leader>jm",
        "<cmd>Obsidian template<CR>",
        desc = "Obsidian Insert Template"
      },
      {
        "<leader>ji",
        "<cmd>Obsidian paste_img<CR>",
        desc = "Obsidian Paste Image from clipboard"
      },
      {
        "<leader>jl",
        "<cmd>Obsidian link<CR>",
        desc = "Obsidian select Link and insert in cursor"
      },
      {
        "<leader>jr",
        "<cmd>Obsidian extract_note<CR>",
        desc = "Obsidian extract selected to new note",
        mode = { "v" },
      },
      {
        "<leader>jl",
        "<cmd>Obsidian link_new<CR>",
        desc = "Obsidian Create new link from selected text",
        mode = { "v" },
      },
    },
    opts = function()
      -- local is_windows = package.config:sub(1, 1) == '\\'
      --
      -- -- Define the variable based on the OS
      --
      -- if is_windows then
      --   -- Retrieve the environment variable for Windows
      --   second_brain_path = os.getenv("PERSONAL_SECOND_BRAIN")
      -- else
      --   -- Retrieve the environment variable for macOS
      --   second_brain_path = os.getenv("WORK_SECOND_BRAIN")
      -- end
      local second_brain_path = os.getenv("SECOND_BRAIN_PATH")
      local nvim_templates = "/99 - Meta/Templates/Nvim"
      return {
        ui = {
          enable = false,
        },
        legacy_commands = false,
        workspaces = {
          {
            name = "personal",
            path = second_brain_path,
          },
        },
        completion = {
          min_chars = 2,
        },
        notes_subdir = "09 - Inbox",
        new_notes_location = "notes_subdir",
        daily_notes = {
          -- Optional, if you keep daily notes in a separate directory.
          folder = "07 - Daily",
          -- Optional, if you want to change the date format for the ID of daily notes.
          date_format = "%Y-%m-%d",
          -- Optional, if you want to change the date format of the default alias of daily notes.
          alias_format = "%B %-d, %Y",
          -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
          template = second_brain_path .. nvim_templates .. "/daily.md",
        },
        -- Specify how to handle attachments.
        attachments = {
          -- The default folder to place images in via `:Obsidian paste_img`.
          -- If this is a relative path it will be interpreted as relative to the vault root.
          -- You can always override this per image by passing a full path to the command instead of just a filename.
          folder = "99 - Meta/Attachments", -- This is the default
        },
        frontmatter = {
          func = function(note)
            -- This is equivalent to the default frontmatter function.
            local out = { tags = note.tags }
            -- `note.metadata` contains any manually added fields in the frontmatter.
            -- So here we just make sure those fields are kept in the frontmatter.
            if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
              for k, v in pairs(note.metadata) do
                out[k] = v
              end
            end
            return out
          end,
        },

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
      "Obsidian",
    },
  },
}
