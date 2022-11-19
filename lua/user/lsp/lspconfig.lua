local lspconfig = require("lspconfig")
local lsp_defaults = lspconfig.util.default_config
lsp_defaults.capabilities = vim.tbl_deep_extend(
  "force",
  lsp_defaults.capabilities,
  require("cmp_nvim_lsp").default_capabilities()
)

lspconfig.sumneko_lua.setup({})

lspconfig.pyright.setup({
  root_dir = function() return vim.fn.getcwd() end,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "strict",
        extraPaths = {
          -- /path/to/repo/root
          -- /path/to/repo/root/plz-out/gen
        },
      },
    },
  },
})

lspconfig.gopls.setup({
  settings = {
    gopls = {
      directoryFilters = { "-plz-out" },
      linksInHover = false,
    },
    root_dir = {"go.mod", ".plzconfig", "src", ".git"},
  }
})
lspconfig.bufls.setup({})
lspconfig.jsonls.setup({})
lspconfig.bashls.setup({})
lspconfig.yamlls.setup({})
lspconfig.please = {
    default_config = {
        cmd = { "plz", "tool", "lps" },
        filetypes = { "please" },
        root_dir = lspconfig.util.root_pattern(".plzconfig"),
    },
}
