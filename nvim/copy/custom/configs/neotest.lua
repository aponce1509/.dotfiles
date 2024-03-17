-- local function getenvs()
--   local path = '.testenvs'
--   local file = io.open(path, 'rb')
--   if not file then return nil end
--
--   local lines = {}
--   while true do
--     local line = file:read()
--     if not line then break end
--     local key, value = line:match("([^=%s]+)%s*=%s*([^=%s]+)")
--     lines[key] = value
--   end
--
--   return lines
--
-- end
--
-- function RunTest()
--   local envs = getenvs()
--   neotest.run.run({env = envs})
-- end

-- vimp.nnoremap( '<localleader>tr', RunTest)

require("neotest").setup {
  adapters = {
    require "neotest-python" {
      -- Extra arguments for nvim-dap configuration
      -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
      dap = { justMyCode = false },
      -- Command line arguments for runner
      -- Can also be a function to return dynamic values
      args = { "--capture=tee-sys", "-o", "log_cli=true", "--log-level", "DEBUG", "-s"},
      -- Runner to use. Will use pytest if available by default.
      -- Can be a function to return dynamic value.
      runner = "pytest",
      -- Custom python path for the runner.
      -- Can be a string or a list of strings.
      -- Can also be a function to return dynamic value.
      -- If not provided, the path will be inferred by checking for
      -- virtual envs in the local directory and for Pipenev/Poetry configs
      -- python = ".venv/bin/python",
      -- Returns if a given file path is a test file.
      -- NB: This function is called a lot so don't perform any heavy tasks within it.
      -- is_test_file = function(file_path)
      --   ...
      -- end,
      -- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test
      -- instances for files containing a parametrize mark (default: false)
      pytest_discover_instances = true,
    },
    icons = {
      running = "…",
    },
  },
}
