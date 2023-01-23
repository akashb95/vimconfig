local lspconfig = require("lspconfig")
local lsp_defaults = lspconfig.util.default_config
lsp_defaults.capabilities = vim.tbl_deep_extend(
  "force",
  lsp_defaults.capabilities,
  require("cmp_nvim_lsp").default_capabilities()
)
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}

lspconfig.sumneko_lua.setup({capabilities=capabilities})

lspconfig.pyright.setup({
  capabilities = capabilities,
  root_dir = function() return vim.fn.getcwd() end,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        -- typeCheckingMode = "strict",
        extraPaths = {
          "/home/akash/src/",
          "/home/akash/src/plz-out/gen",
        },
      },
    },
  },
})

lspconfig.gopls.setup({
  capabilities = capabilities,
  settings = {
    gopls = {
      directoryFilters = { "-plz-out" },
      linksInHover = false,
      analyses = {unusedparams = true,},
      staticcheck = true,
      env = {
        GOPATH = "/home/akash:/home/akash/src/plz-out/go:/home/akash/src/plz-out/gen/third_party/go:/home/akash",
      },
    },
    root_dir = {"go.mod", ".plzconfig", ".git"},
  }
})
-- lspconfig.bufls.setup({capabilities = capabilities})
lspconfig.jsonls.setup({capabilities = capabilities})
lspconfig.bashls.setup({capabilities = capabilities})
lspconfig.yamlls.setup({capabilities = capabilities})
lspconfig.please = {
    capabilities = capabilities,
    default_config = {
        cmd = { "plz", "tool", "lps" },
        filetypes = { "please" },
        root_dir = lspconfig.util.root_pattern(".plzconfig"),
    },
}

lspconfig.sqlls.setup({capabilities = capabilities})

-- Enable folding
require("ufo").setup({
  provider_selector = function(bufnr, filetype, buftype)
    return {'treesitter', 'indent'}
  end
})
