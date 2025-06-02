vim.keymap.set(
  'n',
  '<leader>gst',
  vim.cmd.Git,
  { noremap = true, silent = true, desc = '[g]it [st]atus' }
)

vim.keymap.set(
  'n',
  '<leader>gb',
  '<CMD>Git blame<CR>',
  { noremap = true, silent = true, desc = '[g]it [b]lame' }
)
