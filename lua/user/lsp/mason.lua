require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "sumneko_lua",
    "gopls",
    "pyright",
    -- "bufls",
    "jsonls",
    "bashls",
    "yamlls",
  },
  automatic_installation = true,
})
