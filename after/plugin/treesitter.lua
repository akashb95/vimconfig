local markid = require("markid")

require("nvim-treesitter.configs").setup({
  -- A list of parser names, or "all".
  ensure_installed = {
    "c", "lua",
    "vim", "help",
    "javascript", "typescript",
    "go", "rust", "python", "dart",
    "yaml", "json",
    "query",
  },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,
  highlight = {
    enable = true,
    disable = { "c", "rust" },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "tsn",
      scope_incremental = "n",
      node_decremental = "N",
    },
  },
  -- All identifiers with the same name are highlighted in the same colour.
  markid = {
    enable = true,
    colors = markid.colors.dark,
  },
  textobjects = {
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]P"] = "@parameter.outer",
        ["]C"] = "@class.outer",
        ["]l"] = "@loop.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[P"] = "@parameter.outer",
        ["[C"] = "@class.outer",
        ["[l"] = "@loop.outer",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]L"] = "@loop.outer",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[L"] = "@loop.outer",
      },
    },
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["aP"] = "@parameter.outer",
        ["iC"] = "@class.inner",
        ["aC"] = "@class.outer",
        ["il"] = "@loop.inner",
        ["al"] = "@loop.outer",
        ["ac"] = "@call.outer",
        ["ic"] = "@call.inner",
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
