vim.o.autoread = true
vim.o.swapfile = false
vim.o.clipboard = 'unnamedplus'

vim.o.spell = false

vim.o.number = true
vim.o.relativenumber = true

-- default items in popup menu (e.g. for autocompletion suggestions)
vim.o.pumheight = 7

vim.o.linebreak = true

vim.o.scrolloff = 3

vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true

vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true


-- vim.o.hidden = true -- allow moving to other files without saving

vim.o.cursorline = false
vim.o.lazyredraw = true

vim.o.mouse = "a"

vim.o.showmode = false
vim.o.signcolumn = "yes:2"

-- split screen settings
vim.o.splitbelow = true
vim.o.splitright = true

vim.o.termguicolors = true
vim.o.updatetime = 80

vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.cmd "set whichwrap+=<,>,[,],h,l"

require("file_types").setup({
  lua = {
    tab_size = 2,
    text_width = 120,
  },
  javascript = {
    tab_size = 2,
  },
  typescript = {
    tab_size = 2,
  },
  json = {
    tab_size = 2,
  },
  jsonc = {
    tab_size = 2,
  },
  python = {
    text_width = 120,
  },
  go = {
    text_width = 120,
    indent_with_tabs = false,
  },
  proto = {
    text_width = 120,
  },
  query = {
    tab_size = 2,
  },
  zsh = {
    tab_size = 2,
  },
  markdown = {
    text_width = 120,
    auto_wrap = true,
  },
  html = {
    tab_size = 2,
  },
  sql = {
    tab_size = 2,
    text_width = 120,
  },
  please = {
    text_width = 120,
  },
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
 view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
        { key = "n", action = "create" },
        { key = "s", action = "vsplit" },
      },
    },
  },
})

require("gitsigns").setup({
  update_debounce = 200,
  current_line_blame_opts = { 
    virt_text_pos = "right_align", 
    ignore_whitespace = true,
  },
})

require("lualine").setup({
    options = { theme = "dracula" }
})

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
    "pyright",
    "gopls",
    "bufls",
    "jsonls",
    -- "please",
    "bashls",
    "yamlls",
  },
  automatic_installation = true,
})

local treesitter_configs = require("nvim-treesitter.configs")
treesitter_configs.setup({
  ensure_installed = { "lua", "python", "go", "json", "yaml", "proto" },
  highlight = { enabled = true, },
  indent = { enabled = true, },
})

-- LSP config
local lspconfig = require("lspconfig")
local lsp_defaults = lspconfig.util.default_config
lsp_defaults.capabilities = vim.tbl_deep_extend(
  "force",
  lsp_defaults.capabilities,
  require("cmp_nvim_lsp").default_capabilities()
)

lspconfig.sumneko_lua.setup({})
lspconfig.pyright.setup({})
lspconfig.gopls.setup({})
lspconfig.bufls.setup({})

vim.api.nvim_create_autocmd(
  'LspAttach', 
  {
    desc = 'LSP actions',
    callback = function()
      local bufmap = function(mode, lhs, rhs)
        local opts = {buffer = true}
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Displays hover information about the symbol under the cursor
      bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

      -- Jump to the definition
      bufmap('n', '<C-b>', '<cmd>lua vim.lsp.buf.definition()<cr>')

      -- Jump to declaration
      bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

      -- Lists all the implementations for the symbol under the cursor
      bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

      -- Jumps to the definition of the type symbol
      bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

      -- Lists all the references 
      bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')

      -- Displays a function's signature information
      bufmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

      -- Renames all references to the symbol under the cursor
      bufmap('n', '<F6>', '<cmd>lua vim.lsp.buf.rename()<cr>')

      -- Selects a code action available at the current cursor position
      bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
      bufmap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')

      -- Show diagnostics in a floating window
      bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

      -- Move to the previous diagnostic
      bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

      -- Move to the next diagnostic
      bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
    end
  }
)

-- cmp config
local cmp = require('cmp')
local luasnip = require('luasnip')

local select_opts = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  sources = {
    { name = "path", keyword_length = 2 },
    { name = "nvim_lsp", keyword_length = 1 },
    { name = "buffer", keyword_length = 3 },
    { name = "luasnip", keyword_length = 2 },
  },
  window = {
    documentation = cmp.config.window.bordered()
  },
  formatting = {
    fields = { "menu", "abbr", "kind" },
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = "λ",
        luasnip = "⋗",
        buffer = "Ω",
        path = "🖫",
       }

      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  mapping = {
    ["<Up>"] = cmp.mapping.select_prev_item(select_opts),
    ["<Down>"] = cmp.mapping.select_next_item(select_opts),

    ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
    ["<C-n>"] = cmp.mapping.select_next_item(select_opts),

    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),

    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
    ["<Tab>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),

    ["<C-d>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<C-b>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
})

vim.diagnostic.config({
    virtual_text = false,
    severity_sort = true,
    update_in_insert = true,
    virtual_text = true,
    float = {
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    }
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = "rounded" }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = "rounded" }
)

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" },
    },
    {
        { name = "cmdline" },
    }),
})

-- Autopairs
require("nvim-autopairs").setup({
  map_c_w = true,
  disable_filetype = { "TelescopePrompt", "guihua", "guihua_rust", "clap_input" },
})
if vim.o.ft == 'clap_input' and vim.o.ft == 'guihua' and vim.o.ft == 'guihua_rust' then
  require'cmp'.setup.buffer { completion = {enable = false} }
end

require("go").setup()
vim.cmd "colorscheme darcula"


require('neoscroll').setup()

