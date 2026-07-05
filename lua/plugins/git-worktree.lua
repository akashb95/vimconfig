return {
	"polarmutex/git-worktree.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local telescope = require("telescope")
		telescope.load_extension("git_worktree")

		vim.keymap.set("n", "<leader>gwl", function()
			require("telescope").extensions.git_worktree.git_worktree()
		end, { noremap = true, silent = true, desc = "[g]it [w]orktree [l]ist / switch" })
		vim.keymap.set("n", "<leader>gwc", function()
			local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
			require("telescope").extensions.git_worktree.create_git_worktree({ cwd = root })
		end, { noremap = true, silent = true, desc = "[g]it [w]orktree [c]reate" })
	end,
}
