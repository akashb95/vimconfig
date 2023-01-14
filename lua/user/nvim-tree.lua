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

vim.keymap.set('n', '<leader>e', [[:NvimTreeToggle<CR>]], {})
vim.keymap.set('n', '<leader>E', [[:NvimTreeFindFile<CR>]], {})

