local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require "null-ls"
local cspell = require "cspell"

local on_attach = function(client, bufnr)
  if client.supports_method "textDocument/formatting" then
    vim.api.nvim_clear_autocmds {
      group = augroup,
      buffer = bufnr,
    }
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format {
          bufnr = bufnr,
        }
      end,
    })
  end
end

local sources = {
  null_ls.builtins.formatting.black.with {
    extra_args = { "--line-length", "88" },
  },
  null_ls.builtins.diagnostics.mypy.with {
    extra_args = function()
      local virtual = os.getenv "CONDA_PREFIX" or os.getenv "VIRTUAL_ENV" or "/usr"
      return { "--strict", "--python-executable", virtual .. "/bin/python3" }
    end,
  },

  cspell.diagnostics.with {
    extra_args = { "--locale", "en,es" },
    filetypes = { "python", "markdown", "md" },
    -- Set the severity to HINT for unknown words
    diagnostics_postprocess = function(diagnostic)
      diagnostic.severity = vim.diagnostic.severity["HINT"]
    end,
  },
  cspell.code_actions,
  null_ls.builtins.formatting.prettierd,
  null_ls.builtins.diagnostics.markdownlint,
}

-- using register method
null_ls.setup {
  sources = sources,
  on_attach = on_attach,
}
