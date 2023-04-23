local lsp = require("lsp-zero")
local telescope_builtin = require("telescope.builtin")
local wk = require("which-key")

local _lsp_format_timeout = 2000 -- Milliseconds

lsp.preset("recommended")

lsp.ensure_installed({
  "tsserver",
  "eslint",
  "lua_ls",
  "rust_analyzer",
  "pyright",
  "gopls",
  "bufls",
  "sqlls",
  "jsonls",
  "bashls",
  "yamlls",
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  -- Navigate suggestions.
  ["<Up>"] = cmp.mapping.select_prev_item(cmp_select),
  ["<Down>"] = cmp.mapping.select_next_item(cmp_select),
  -- Autocomplete - behaviour configured to emulate IntelliJ.
  ["<CR>"] = cmp.mapping.confirm({
    behavior = cmp.ConfirmBehavior.Insert,
    select = true
  }),
  ["<Tab>"] = cmp.mapping.confirm({
    behavior = cmp.ConfirmBehavior.Replace,
    select = true
  }),
})

lsp.setup_nvim_cmp({ mapping = cmp_mappings })

cmp.setup({
  completion = {
    completeopt = "menu,menuone,noinsert"
  },
  preselect = "item",
  sources = {
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "path",    option = { trailing_slash = true, label_trailing_slash = true } },
    { name = "buffer",  keyword_length = 3 },
    { name = "luasnip", keyword_length = 2 },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    { { name = "path" } },
    { { name = "cmdline" } }
  ),
})

lsp.on_attach(function(_, bufnr)
  local opts = { buffer = bufnr, remap = false }

  -- Use attached LSPs to format buffer on save. Ordering not guaranteed.
  lsp.buffer_autoformat()

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)

  vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, opts)

  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)

  vim.keymap.set("n", "gr", function() telescope_builtin.lsp_references() end, opts)

  vim.keymap.set(
    { "n", "x" },
    "gq",
    function() vim.lsp.buf.format({ async = false, timeout_ms = _lsp_format_timeout }) end,
    opts
  )

  vim.keymap.set(
    { "n", "x" },
    "<F6>",
    function() vim.lsp.buf.rename() end,
    opts
  )

  wk.register({
    g = {
      name = "LSP actions",
      d = { "Go to definition" },
      D = { "Go to declaration" },
      l = { "Diagnostic float" },
      r = { "Go to references" },
      q = { "Format buffer" },
      o = { "Go to type definition " },
    },
  })
end)

-- Integrate with ufo for LSP-based folding.

lsp.set_server_config({
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }
    }
  }
})

local lspconfig = require("lspconfig")
local lspconfig_configs = require("lspconfig.configs")
local lspconfig_util = require("lspconfig.util")

-- Add configuration for the Please language server (it is not included in lspconfigs by default)

vim.filetype.add({
  extension = {
    build_defs = "please",
    build_def = "please",
    build = "please",
    plz = "please",
  },
  filename = {
    ["BUILD"] = "please",
  },
})

lspconfig_configs.please = {
  default_config = {
    cmd = { "plz", "tool", "lps" },
    filetypes = { "please" },
    root_dir = lspconfig.util.root_pattern(".plzconfig"),
  },
}

lspconfig.gopls.setup({
  settings = {
    gopls = {
      analyses = { unusedparams = true },
      directoryFilters = { "-plz-out", "-cloud", "-instances" },
      linksInHover = false,
      staticcheck = true,
    },
  },
  root_dir = function(fname)
    local go_mod_root = lspconfig_util.root_pattern("go.mod")(fname)
    if go_mod_root then
      return go_mod_root
    end
    local plz_root = lspconfig_util.root_pattern(".plzconfig")(fname)
    local gopath_root = lspconfig_util.root_pattern("src")(fname)
    if plz_root and gopath_root then
      vim.env.GOPATH = string.format("%s:%s/plz-out/go", gopath_root, plz_root)
      vim.env.GO111MODULE = "off"
    end
    return vim.fn.getcwd()
  end
})

lspconfig.pyright.setup({
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        extraPaths = {
          "/home/akash/core3/src",
          "/home/akash/core3/src/plz-out/gen",
        }
      },
    },
  },
})

lsp.setup()

-- Organise Go imports on save.
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
    vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
  end
})
