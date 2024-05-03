local lspzero = require("lsp-zero")
local telescope_builtin = require("telescope.builtin")
local wk = require("which-key")

local _lsp_format_timeout = 2000 -- Milliseconds

lspzero.preset("recommended")

lspzero.ensure_installed({
  "lua_ls",
  "rust_analyzer",
  "gopls",
  "pylsp",
  "bufls",
  "sqlls",
  "jsonls",
  "bashls",
  "yamlls",
})

-- Autocomplete
local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lspzero.defaults.cmp_mappings({
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

lspzero.setup_nvim_cmp({ mapping = cmp_mappings })

cmp.setup({
  completion = {
    completeopt = "menu,menuone,noinsert"
  },
  preselect = "item",
  sources = {
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "rg",      keyword_length = 2 },
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

-- LSP setup
local on_attach_lsp = function(_, bufnr)
  local opts = { buffer = bufnr, remap = false }

  -- Use attached LSPs to format buffer on save. Ordering not guaranteed.
  lspzero.buffer_autoformat()

  -- Set keybindings
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)

  vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, opts)

  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)

  vim.keymap.set("n", "gr", function() telescope_builtin.lsp_references() end, opts)

  vim.keymap.set(
    { "n", "x" },
    "gf",
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
      f = { "Format buffer" },
      i = { "List all implementations for symbol under cursor in quickfix" },
      l = { "Diagnostic float" },
      o = { "Go to type definition " },
      r = { "Go to references" },
    },
    K = { name = "Display hover info about symbol under the cursor in a float." },
  })
end

lspzero.on_attach(on_attach_lsp)

-- Integrate with ufo for LSP-based folding.

lspzero.set_server_config({
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

-- Configure lua language server for Neovim
local lua_opts = lspzero.nvim_lua_ls()
lspconfig.lua_ls.setup(lua_opts)


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
      analyses = {
        unusedparams = true,
      },
      directoryFilters = {
        "-" .. vim.fn.getcwd() .. "/plz-out",
        "+" .. vim.fn.getcwd() .. "/plz-out/go",
      },
      linksInHover = false,
      staticcheck = true,
      -- gofumpt = true,  -- a stricter gofmt
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

lspconfig.pylsp.setup({
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          hangClosing = false,
          maxLineLength = 100,
        },
      }
    }
  },
  root_dir = function(fname)
    local plz_root = lspconfig_util.root_pattern(".plzconfig")(fname)
    return plz_root
  end,
  single_file_support = false,
})

lspzero.setup()

-- Organise Go imports on save.
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 2000)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({ async = false })
  end
})
