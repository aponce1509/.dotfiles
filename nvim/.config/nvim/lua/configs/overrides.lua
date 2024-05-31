local M = {}

M.telescope = {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "-L",
      "--color=never",
      "--hidden",
      "--no-ignore",
      "--glob",
      "!**/.git/*",
      "--glob",
      "!**/vscode-*/*",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
  },
}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "markdown",
    "markdown_inline",
    "rust",
    "latex",
    "python",
    "vimdoc",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
  highlight = {
    additional_vim_regex_highlight = false,
  },
}

M.mason = {
  ensure_installed = { -- lua stuff
    "pyright",
    "black",
    "mypy",
    "ruff-lsp",
    "python-lsp-server", -- web dev stuff
    "lua-language-server",
    "stylua", -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier", -- c/cpp stuff
    "clangd",
    "clang-format", -- shell stuff
    "shfmt",
    "codespell",
    "misspell",
    "cspell",
    "marksman",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },
  filters = {
    exclude = {},
    dotfiles = false,
    git_ignored = false,
  },
  renderer = {
    highlight_git = false,
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },

      glyphs = {
        default = "󰈚",
        symlink = "",
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
          symlink_open = "",
          arrow_open = "",
          arrow_closed = "",
        },
        git = {
          unstaged = "",
          staged = "",
          unmerged = "",
          renamed = "",
          untracked = "",
          deleted = "",
          ignored = "",
        },
      },
    },
  },
}
return M
