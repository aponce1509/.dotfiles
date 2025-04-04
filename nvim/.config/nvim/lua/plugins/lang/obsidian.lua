-- raise a error if the env var is not set
local root_path = os.getenv("SECOND_BRAIN_PATH") or error("SECOND_BRAIN_PATH is not set")
return {
  {
    -- https://github.com/epwalsh/obsidian.nvim
    "epwalsh/obsidian.nvim",
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

      { "<leader>jr", "<cmd> ObsidianRename <CR>", desc = "Obsidian New File" },
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
        "<cmd> ObsidianTemplate <CR>",
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
        follow_url_func = function(url)
          -- Open the URL in the default web browser.
          vim.fn.jobstart({ "open", url }) -- Mac OS
          -- vim.fn.jobstart({"xdg-open", url})  -- linux
          -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
          -- vim.ui.open(url) -- need Neovim 0.10.0+
        end,
        workspaces = {
          {
            name = "personal",
            path = second_brain_path,
          },
        },
        completion = {
          nvim_cmp = false,
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
        wiki_link_func = function(opts)
          if opts.id == nil then
            return string.format("[[%s]]", opts.label)
          elseif opts.label ~= opts.id then
            return string.format("[[%s|%s]]", opts.id, opts.label)
          else
            return string.format("[[%s]]", opts.id)
          end
        end,
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
