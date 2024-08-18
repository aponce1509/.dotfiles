--- File lister module for Telescope integration.
--- @class FileLister
local M = {}

--- List files in specified folders recursively.
--- @param root string The root directory path
--- @param folders string|string[] A folder or list of folders to search
--- @return string[] List of file paths
function M.list_files(root, folders)
  local files = {}
  local folder_list = type(folders) == "string" and { folders } or folders

  local function add_files_recursively(dir)
    local ok, result = pcall(vim.fn.glob, dir .. "/*")
    if ok and result then
      for entry in result:gmatch "[^\n]+" do
        if vim.fn.isdirectory(entry) == 1 then
          add_files_recursively(entry)
        else
          table.insert(files, entry)
        end
      end
    end
  end

  for _, folder in ipairs(folder_list) do
    add_files_recursively(root .. folder)
  end

  return files
end

--- Show Telescope picker with list of files.
--- @param root string The root directory path
--- @param folders string|string[] A folder or list of folders to search
--- @param prompt_title? string Optional custom prompt title
function M.show_list_files(root, folders, prompt_title)
  local folder_list = type(folders) == "string" and { folders } or folders
  local selected_files = M.list_files(root, folder_list)
  local basename_to_path = {}
  local display_to_path = {}

  for _, file in ipairs(selected_files) do
    local basename = vim.fn.fnamemodify(file, ":t")
    local relative_path = file:sub(#root + 1) -- Remove root from the path
    basename_to_path[basename] = file
    display_to_path[basename] = file
  end

  local display_names = vim.tbl_keys(display_to_path)

  prompt_title = prompt_title or folder_list[1]

  local conf = require("telescope.config").values
  require("telescope.pickers")
      .new({}, {
        prompt_title = prompt_title,
        finder = require("telescope.finders").new_table {
          results = display_names,
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry,
              ordinal = entry,
              path = display_to_path[entry],
            }
          end,
        },
        previewer = conf.file_previewer {},
        sorter = conf.generic_sorter {},
        attach_mappings = function(prompt_bufnr)
          require("telescope.actions.set").select:replace(function(_, type)
            local entry = require("telescope.actions.state").get_selected_entry()
            local full_path = display_to_path[entry.value]
            if full_path then
              require("telescope.actions").close(prompt_bufnr)
              vim.cmd("edit " .. vim.fn.fnameescape(full_path))
            end
          end)
          return true
        end,
      })
      :find()
end

return M
