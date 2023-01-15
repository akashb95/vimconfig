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

