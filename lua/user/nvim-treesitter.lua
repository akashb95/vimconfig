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
              ["[a"] = "@parameter.inner",
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

