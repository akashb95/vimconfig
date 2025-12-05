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
							-- schema = {
							-- 	model = {
							-- 		default = "gemini-3-pro-preview",
							-- 	},
							-- },
							env = {
								-- 1. Execute the 1Password CLI command
								-- 2. vim.trim() removes the trailing newline character
								api_key = vim.trim(vim.fn.system({
									"op",
									"read",
									"op://Employee/ukafu5czkq37oo7thictjenh4e/credential",
								})),
							},
						})
					end,
				},
			},
		})
		vim.keymap.set(
			"n",
			"<Leader>cco",
			"<cmd>CodeCompanionChat<cr>",
			{ desc = "[c]odecompanion [c]hat [o]pen", noremap = true, silent = true }
		)
		vim.keymap.set(
			{ "n", "v" },
			"<Leader>cct",
			"<cmd>CodeCompanionChat Toggle<cr>",
			{ desc = "[c]odecompanion [c]hat [t]oggle", noremap = true, silent = true }
		)
	end,
}
