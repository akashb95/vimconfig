-- Linebreaks
vim.keymap.set('n', '<C-CR>', 'i<CR><ESC>', {})
vim.keymap.set('n', '<S-CR>', 'O<ESC>', {})

-- Insert-mode navigation
vim.keymap.set("i", "jj", "<esc>")
vim.keymap.set("i", "II", "<esc>I")
vim.keymap.set("i", "AA", "<esc>A")
