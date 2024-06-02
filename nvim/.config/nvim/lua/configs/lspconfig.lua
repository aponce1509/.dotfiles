-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "cssls", "marksman", "digestif", "markdown_oxide" }

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- typescript
lspconfig.tsserver.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}

--python
-- local py_right_capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    python = {
      analysis = { diagnosticMode = "off", typeCheckingMode = "off" },
      inlayHints = true,
    },
  },
}
-- require("lspconfig").pylyzer.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   {
--     python = {
--       checkOnType = false,
--       diagnostics = false,
--       inlayHints = true,
--       smartCompletion = true,
--     },
--   },
-- }
-- lspconfig.jedi_language_server.setup({
--   capabilities = capabilities,
--   on_attach = on_attach,
-- init_options = {
--   completion = {
--     disableSnippets = true,
--   },
-- }
-- })
lspconfig.ruff_lsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "python" },
}
-- latex
lspconfig.texlab.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "tex", "latex", "markdown", "md" },
}
