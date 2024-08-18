local second_brain_path = "/Users/aponce1509/OneDrive/Documents/2_areas/SecondBrain/"

local M = {}

function M.list_files()
  local folders = {
    "00 - Map of Contents",
    -- Add more folders as needed
  }

  local files = {}
  for _, folder in ipairs(folders) do
    local ok, result = pcall(vim.fn.glob, second_brain_path .. folder .. "/*")
    if ok and result then
      for file in result:gmatch "[^\n]+" do
        table.insert(files, file)
      end
    end
  end
  return files
end

return M
