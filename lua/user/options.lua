vim.o.swapfile = false
vim.o.clipboard = 'unnamedplus'

vim.o.spell = false

vim.o.number = true
vim.o.relativenumber = true

-- default items in popup menu (e.g. for autocompletion suggestions)
vim.o.pumheight = 5

vim.o.linebreak = true

vim.o.scrolloff = 5

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

require("nvim-treesitter.configs").setup({
  ensure_installed = {"python", "go", "lua", "json", "yaml", "proto"},
  highlight = { enabled = true },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
  indent = { enabled = true, },
  playground = { enable = true },
  incremental_selection = {
      enable = true,
      keymaps = {
          init_selection = "tsn",
          scope_incremental = "n",
          node_decremental = "N",
      },
  },
  textobjects = {
      select = {
          enable = true,
          lookahead = false,
          keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ap"] = "@parameter.outer",
              ["ip"] = "@parameter.inner",
          },
      },
      move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
              ["]f"] = "@function.outer",
              ["]p"] = "@parameter.outer",
          },
          goto_previous_start = {
              ["]f"] = "@function.outer",
          },
          goto_next_end = {
              ["[f"] = "@function.outer",
              ["[a"] = "@paramter.inner",
          },
          goto_previous_end = {
              ["[f"] = "@function.outer",
          },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>;"] = "@swappable",
        },
        swap_previous = {
          ["<leader>,"] = "@swappable",
        },
      },
  },
})

-- cmp config
local cmp = require('cmp')
local luasnip = require('luasnip')

local select_opts = { behavior = cmp.SelectBehavior.Select }

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
        nvim_lsp = "Λ",
        luasnip = "✂",
        buffer = "Ω",
        path = "⨒",
      }

      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  mapping = {
    -- Navigate suggestions.
    ["<Up>"] = cmp.mapping.select_prev_item(select_opts),
    ["<Down>"] = cmp.mapping.select_next_item(select_opts),

    -- Alternative keymaps to navigate suggestions.
    ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
    ["<C-n>"] = cmp.mapping.select_next_item(select_opts),

    -- Scroll in suggestions window.
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),

    -- Cancel.
    ["<C-e>"] = cmp.mapping.abort(),

    -- Autocomplete - behaviour configured to emulate IntelliJ.
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
  require 'cmp'.setup.buffer { completion = { enable = false } }
end

vim.cmd "colorscheme darcula"

-- Smooth scrolling
require('neoscroll').setup()

vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
