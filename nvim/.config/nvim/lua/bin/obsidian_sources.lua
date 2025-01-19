local blink = require('blink.cmp')

local function add_obsidian_sources()
  -- Add obsidian provider
  blink.add_provider('obsidian', {
    name = 'obsidian',
    module = 'blink.compat.source',
    opts = {
      source = require("cmp_obsidian")
    }
  })

  blink.add_provider('obsidian_new', {
    name = 'obsidian_new',
    module = 'blink.compat.source',
    opts = {
      source = require("cmp_obsidian_new")
    }
  })

  blink.add_provider('obsidian_tags', {
    name = 'obsidian_tags',
    module = 'blink.compat.source',
    opts = {
      source = require("cmp_obsidian_tags")
    }
  })

  -- Add to default sources if they aren't already there
  local config = require('blink.cmp.config')
  for _, source in ipairs({ 'obsidian', 'obsidian_new', 'obsidian_tags' }) do
    if not vim.tbl_contains(config.sources.default, source) then
      table.insert(config.sources.default, source)
    end
  end
end

vim.api.nvim_create_user_command('AddObsidianSources', function()
  add_obsidian_sources()
end, {})


-- -- You can call this when certain conditions are met
-- -- For example:
-- if vim.bo.filetype == 'markdown' then
--   add_obsidian_sources()
--
-- end
