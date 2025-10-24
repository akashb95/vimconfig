-- vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "gd", function()
	vim.lsp.buf.definition({ reuse_win = true })
end, { desc = "[g]o to [d]eclaration", noremap = true })
-- vim.keymap.set("n", "go", vim.lsp.buf.type_definition, {})
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "df", vim.diagnostic.open_float, { desc = "open [d]iagnostic f[l]oat", noremap = true })
vim.keymap.set("n", "tdf", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
	if vim.diagnostic.is_enabled() then
		vim.notify("Showing inline diagnostics")
	else
		vim.notify("Hiding inline diagnostics")
	end
end, { desc = " [t]oggle [d]iagnostic [f]loat" })
