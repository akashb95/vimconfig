return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"mfussenegger/nvim-dap",
		"mfussenegger/nvim-dap-python",
		"nvim-telescope/telescope.nvim",
	},
	branch = "regexp", -- This is the recommended branch for the latest features and Neovim >= 0.10
	lazy = false,
	config = function()
		local venv_selector = require("venv-selector")
		local hooks = require("venv-selector.hooks")

		venv_selector.setup({
			settings = {
				options = {
					notify_user_on_venv_activation = true,
				},
				hooks = {
					-- Include default hooks
					hooks.basedpyright_hook,
					hooks.pyright_hook,
					hooks.pylance_hook,
					hooks.pylsp_hook,
					-- Add our custom hook for Pyrefly
					function(venv_python)
						hooks.set_python_path_for_client("pyrefly", venv_python)
					end,
				},
			},
		})
	end,
	keys = {
		{ "<leader>tvs", "<cmd>VenvSelect<cr>", desc = "[t]elescope [v]env [s]elect" },
		{ "<leader>tvc", "<cmd>VenvSelectCached<cr>", desc = "[t]elescope [v]env select [c]ached" },
	},
}
