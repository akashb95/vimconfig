require("opts")
require("custom_keymaps")

require("lazyconfig")

vim.lsp.enable("lua_ls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("pyright")
vim.lsp.enable("gopls")

vim.lsp.config("*", {
	capabilities = {
		textDocument = {
			foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			},
		},
	},
})
