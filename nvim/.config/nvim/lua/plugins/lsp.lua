return { -- LSP keymaps
-- https://www.lazyvim.org/plugins/lsp#%EF%B8%8F-customizing-lsp-keymaps
-- https://www.lazyvim.org/configuration/keymaps#lsp-keymaps
{
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            ["*"] = {
                keys = {{
                    "<leader>.",
                    vim.lsp.buf.code_action,
                    desc = "Code Action",
                    mode = {"n", "v"},
                    has = "codeAction"
                }}
            }
        }
    }
}}
