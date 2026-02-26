return {
	"olimorris/codecompanion.nvim",
	version = "v17.33.0",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		local codecompanion = require("codecompanion")

		codecompanion.setup({
			strategies = {
				chat = {
					adapter = "gemini",
					keymaps = {
						close = false,
					},
					opts = {
						completion_provider = "blink",
					},
				},
				inline = {
					adapter = "gemini_cli",
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
								api_key = "cmd:op read op://Employee/ukafu5czkq37oo7thictjenh4e/credential --no-newline",
							},
						})
					end,
				},
		})

		vim.keymap.set(
			{ "n" },
			"<Leader>cci",
			"<cmd>CodeCompanion<cr>",
			{ desc = "[c]ode[c]ompanion [c]hat [i]nline", noremap = true, silent = true }
		)
		vim.keymap.set(
			{ "n" },
			"<Leader>cco",
			"<cmd>CodeCompanionChat<cr>",
			{ desc = "[c]ode[c]ompanion [c]hat [o]pen", noremap = true, silent = true }
		)
		vim.keymap.set(
			{ "n" },
			"<Leader>cct",
			"<cmd>CodeCompanionChat Toggle<cr>",
			{ desc = "[c]ode[c]ompanion [c]hat [t]oggle", noremap = true, silent = true }
		)
		vim.keymap.set(
			{ "n", "v" },
			"<Leader>cca",
			"<CMD>CodeCompanionActions<CR>",
			{ desc = "[c]ode[c]ompanion [a]ctions", noremap = true, silent = true }
		)
	end,
}
