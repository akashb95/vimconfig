-- Linebreaks
vim.keymap.set('n', '<C-CR>', 'i<cr><esc>', {})
vim.keymap.set('n', '<S-CR>', 'O<esc>', {})

-- Insert-mode navigation
vim.keymap.set("i", "jj", "<esc>")
vim.keymap.set("i", "II", "<esc>I")
vim.keymap.set("i", "AA", "<esc>A")
