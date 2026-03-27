local VIRTUAL_ENV_DIRECTORY_CANDIDATES = {
	"venv",
	".venv",
}

return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"mfussenegger/nvim-dap",
		"mfussenegger/nvim-dap-python",
		"nvim-telescope/telescope.nvim",
	},
	lazy = false,
	config = function()
		local vs = require("venv-selector")

		vs.setup({
			settings = {
				options = {
					notify_user_on_venv_activation = true,
				},
			},
		})

		-- Auto-activate .venv or venv in the project root if no venv is currently active
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "python",
			callback = function(args)
				-- If a venv is already active (e.g., loaded from cache), we're done
				if vs.python() ~= nil then
					return
				end

				-- Find the project root (Git root or Python project root)
				local root = vim.fs.root(args.buf, { ".git", "pyproject.toml", "setup.py" })
				if not root then
					return
				end

				-- Check for .venv or venv directory
				for _, venv_name in ipairs(VIRTUAL_ENV_DIRECTORY_CANDIDATES) do
					local python_path = vim.fs.joinpath(root, venv_name, "bin", "python")
					if vim.fn.executable(python_path) == 1 then
						vs.activate_from_path(python_path)
						return
					end
				end
			end,
		})
	end,
	keys = {
		{ "<leader>tvs", "<cmd>VenvSelect<cr>", desc = "[t]elescope [v]env [s]elect" },
		{ "<leader>tvc", "<cmd>VenvSelectCached<cr>", desc = "[t]elescope [v]env select [c]ached" },
	},
}
