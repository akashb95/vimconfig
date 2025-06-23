require("opts")
require("custom_keymaps")

require("lazyconfig")

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
