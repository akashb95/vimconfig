return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		local codecompanion = require("codecompanion")
		codecompanion.setup({
			strategies = {
				chat = { adapter = "gemini" },
				inline = { adapter = "gemini" },
				agent = { adapter = "gemini" },
			},
			adapters = {
				http = {
					gemini = function()
						return require("codecompanion.adapters").extend("gemini", {
							schema = {
								model = {
									default = "gemini-3-pro-preview",
								},
							},
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
				acp = {
					gemini_cli = function()
						return require("codecompanion.adapters").extend("gemini_cli", {
							defaults = {
								auth_method = "gemini-api-key", -- Or "oauth-personal" | "vertex-ai"
							},
							env = {
								-- Reusing your existing 1Password CLI setup for the API key
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

		codecompanion.setup({
			strategies = {
				inline = {
					keymaps = {
						accept_change = {
							modes = { n = "ga" },
							description = "Accept the suggested change",
						},
						reject_change = {
							modes = { n = "gr" },
							opts = { nowait = true },
							description = "Reject the suggested change",
						},
						stop = {
							modes = { n = "q" },
							index = 4,
							callback = "keymaps.stop",
							description = "Stop (abort) request",
						},
					},
				},
			},
		})
	end,
}
