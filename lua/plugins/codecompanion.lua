return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("codecompanion").setup({
			strategies = {
				chat = { adapter = "gemini" },
				inline = { adapter = "gemini" },
				agent = { adapter = "gemini" },
			},
			adapters = {
				http = {
					gemini = function()
						return require("codecompanion.adapters").extend("gemini", {
							env = {
								-- 1. Execute the 1Password CLI command
								-- 2. vim.trim() removes the trailing newline character
								api_key = vim.trim(vim.fn.system({
									"op",
									"read",
									"op://Tech/v3siwxry32kg75jrmmewwy34ye/credential",
								})),
							},
						})
					end,
				},
			},
		})
	end,
}
