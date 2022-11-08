local map = vim.api.nvim_set_keymap

-- Toggle nvim-tree
map('n', '<leader>e', [[:NvimTreeToggle<CR>]], {})
map('n', '<leader>f', [[:NvimTreeFindFile<CR>]], {})

