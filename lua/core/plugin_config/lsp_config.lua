-- Set up Mason and Mason-LSPConfig
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "ts_ls", "graphql", "elixirls", "jdtls" } -- Add jdtls here
})

-- Buffer key mappings for LSP features
local bufopts = { noremap = true, silent = true }
local on_attach = function(_, _)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'gh', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
end

-- Global key mappings for LSP features
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
vim.keymap.set('n', 'gh', vim.lsp.buf.hover, bufopts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

-- Set up capabilities for cmp-nvim-lsp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Set up LSP for Lua, TypeScript, Elixir, TailwindCSS, and Java

-- Lua LSP
require("lspconfig").lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

-- TypeScript LSP
require("lspconfig").ts_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

-- Elixir LSP
require("lspconfig").elixirls.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

-- TailwindCSS LSP
require("lspconfig").tailwindcss.setup {
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          { "cva\\(([^)]*)\\)",
            "[\"'`]([^\"'`]*).*?[\"'`]" },
        },
      },
    },
  },
}

-- Java LSP (jdtls setup)
require("lspconfig").jdtls.setup {
  cmd = { "jdtls" }, -- make sure Mason put jdtls in PATH
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = require("lspconfig").util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle"),
  settings = {
    java = {
      format = { enabled = true },
    },
  },
}

-- Disable virtual text for diagnostics
vim.diagnostic.config({ virtual_text = false })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
