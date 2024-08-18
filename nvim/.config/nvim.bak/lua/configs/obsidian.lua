require("obsidian").setup {
  workspaces = {
    {
      name = "personal",
      path = "/Users/aponce1509/OneDrive/Documents/2_areas/SecondBrain/",
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
    template = "/Users/aponce1509/OneDrive/Documents/2_areas/SecondBrain/99 - Meta/Templates/Nvim/daily.md",
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
