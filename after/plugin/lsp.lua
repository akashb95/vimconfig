-- local lspzero = require("lsp-zero")
local telescope_builtin = require("telescope.builtin")
local wk = require("which-key")

local _lsp_format_timeout = 2000 -- Milliseconds

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

require('lspconfig.configs').please = {
  default_config = {
    cmd = { 'plz', 'tool', 'lps' },
    filetypes = { 'please' },
    root_dir = lspconfig_util.root_pattern('.plzconfig'),
  },
}
require('lspconfig').please.setup({})

-- Organise Go imports on save.
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local enc = (vim.lsp.get_client_by_id(0) or {}).offset_encoding or "utf-16"
    local params = vim.lsp.util.make_range_params(0, enc)
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
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({ async = false })

  -- Use attached LSPs to format buffer on save. Ordering not guaranteed.
  -- lspzero.buffer_autoformat()
  end
})

--  This function gets run when an LSP attaches to a particular buffer.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('options-lsp-attach', { clear = true }),
  callback = function(event)
    -- Unset 'formatexpr'
    -- vim.bo[event.buf].formatexpr = nil
    -- Unset 'omnifunc'
    -- vim.bo[event.buf].omnifunc = nil

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

    local opts = { buffer = event.buf, remap = false }

    -- Set keybindings
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

    -- local function on_list(options)
    --   vim.fn.setqflist({}, ' ', options)
    --   -- vim.cmd.cfirst()
    -- end

    -- wk.add {
    --   { "g",  group = "[g]o to...", mode = {"n"} },
    --   { "gd", function() vim.lsp.buf.definition({ on_list = on_list, loclist = true }) end, desc = "[d]efinition", mode = {"n"} },
    --   { "gl", vim.diagnostic.open_float,                                         desc = "diagnostic f[l]oat", mode = {"n"} },
    --   { "go", desc = "type definition for [o]bject" },
    --   { "gr", telescope_builtin.lsp_references,                                  desc = "[g]o to references in telescope", mode = {"n"} },
    --   { "K",  vim.lsp.buf.hover,                                                 desc = "Do[K]umentation float", mode = {"n"} },
    -- }
    end
  end,
})
