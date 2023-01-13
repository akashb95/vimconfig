-- Toggle nvim-tree
vim.keymap.set('n', '<leader>e', [[:NvimTreeToggle<CR>]], {})
vim.keymap.set('n', '<leader>E', [[:NvimTreeFindFile<CR>]], {})

-- local current_fpath = vim.api.nvim_buf_get_name(0)
-- vim.keymap.set('n', '<leader>o', [[:NvimTreeOpen ]], {})

-- Linebreaks
vim.keymap.set('n', '<C-CR>', 'i<CR><ESC>', {})
vim.keymap.set('n', '<S-CR>', 'O<ESC>', {})

-- Insert-mode navigation
vim.keymap.set("i", "jj", "<esc>")
vim.keymap.set("i", "II", "<esc>I")
vim.keymap.set("i", "AA", "<esc>A")

-- Please
local ok, please = pcall(require, "please")
if not ok then return
else
  vim.keymap.set("n", "<leader>pb", please.build, { silent = true } )
  vim.keymap.set("n", "<leader>py", please.yank, { silent = true } )
end

-- Telescope
local telescope_builtin = require("telescope.builtin")
local telescope_extensions = require("telescope").extensions
local reporoot_ok, reporoot = pcall(vim.fn.systemlist, "git rev-parse --show-toplevel")
if reporoot_ok then
  vim.keymap.set("n", "<leader>fg", function() telescope_extensions.live_grep_args.live_grep_args() end)
  vim.keymap.set("n", "<leader>ff", function() telescope_builtin.find_files({ cwd = reporoot[1] }) end)
else
  vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, {})
  vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, {})
end
vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, {})

-- LSP

-- Displays hover information about the symbol under the cursor
vim.keymap.set('n', 'K', vim.lsp.buf.hover)

-- Jump to the definition
vim.keymap.set('n', '<C-b>', vim.lsp.buf.definition)

-- Jump to declaration
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)

-- Lists all the implementations for the symbol under the cursor
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)

-- Jumps to the definition of the type symbol
vim.keymap.set('n', 'go', vim.lsp.buf.type_definition)

-- Lists all the references
vim.keymap.set('n', 'gr', vim.lsp.buf.references)

-- Displays a function's signature information
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help)

-- Renames all references to the symbol under the cursor
vim.keymap.set('n', '<F6>', vim.lsp.buf.rename)

-- Selects a code action available at the current cursor position
vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action)
-- vim.keymap.set('x', '<F4>', vim.lsp.buf.range_code_action)

-- Show diagnostics in a floating window
vim.keymap.set('n', 'gl', vim.diagnostic.open_float)

-- Move to the previous diagnostic
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)

-- Move to the next diagnostic
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
