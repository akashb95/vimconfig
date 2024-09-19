local lspzero = require("lsp-zero")
local telescope_builtin = require("telescope.builtin")
local wk = require("which-key")
local cmp = require("cmp")
local luasnip = require("luasnip")

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
  ["<Tab>"] = cmp.mapping(
    function(fallback)
      -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
      if cmp.visible() then
        local entry = cmp.get_selected_entry()
        if not entry then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        end
        cmp.confirm()
      else
        fallback()
      end
    end,
    { "i", "s", "c", }
  ),
})

lspzero.setup_nvim_cmp({ mapping = cmp_mappings })

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

cmp.setup({
  completion = {
    completeopt = "menu,menuone,noinsert"
  },
  preselect = "item",

  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "nvim_lua" },
    { name = "buffer",  keyword_length = 3 },
    { name = "path",    option = { trailing_slash = true, label_trailing_slash = true } },
    { name = "rg",      keyword_length = 2 },
  },

  ["<CR>"] = cmp.mapping.confirm { select = true },
  ["<Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end, { "i", "s" }),
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, { "i", "s" }),

  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
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
    "<leader>fmt",
    function() vim.lsp.buf.format({ async = false, timeout_ms = _lsp_format_timeout }) end,
    opts
  )

  vim.keymap.set(
    { "n", "x" },
    "<F6>",
    function() vim.lsp.buf.rename() end,
    opts
  )

  wk.add({
    g = { group = "[g]o to..." },
    gd = { desc = "[g]o to [d]efinition" },
    gD = { desc = "[g]o to [D]eclaration" },
    gi = { desc = "[g]o to all [i]mplementations for symbol under cursor in quickfix" },
    gl = { desc = "[g]o to diagnostic f[l]oat" },
    go = { desc = "[g]o to type definition for [o]bject" },
    gr = { desc = "[g]o to references" },
    K = { desc = "Do[K]umentation float" }
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

-- vim.lsp.set_log_level(vim.log.levels.OFF)

--  This function gets run when an LSP attaches to a particular buffer.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('options-lsp-attach', { clear = true }),
  callback = function(event)
    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})
