-- vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "gd", function()
	vim.lsp.buf.definition({ reuse_win = true })
end, { desc = "[g]o to [d]eclaration", noremap = true })
-- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
-- vim.keymap.set("n", "go", vim.lsp.buf.type_definition, {})
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
-- vim.keymap.set("n", "<leader>ge", vim.diagnostic.goto_next, {})
-- vim.keymap.set("n", "<leader>gp", vim.diagnostic.goto_prev, {})
-- -- Map find references to telescope picker
-- vim.keymap.set("n", "grr", function()
-- 	require("telescope.builtin").lsp_references({
-- 		show_line = true,
-- 	})
-- end, {})
