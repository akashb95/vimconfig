return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
	keys = {
		{ "<leader>gdvo", "<cmd>DiffviewOpen<cr>", desc = "[g]it [d]iff[v]iew [o]pen" },
		{ "<leader>gdvc", "<cmd>DiffviewClose<cr>", desc = "[g]it [d]iff[v]iew [c]lose" },
		{ "<leader>gdvh", "<cmd>DiffviewFileHistory<cr>", desc = "[g]it [d]iff[v]iew [h]istory (repo)" },
		{ "<leader>gdvf", "<cmd>DiffviewFileHistory %<cr>", desc = "[g]it [d]iff[v]iew [f]ile history" },
	},
	config = function()
		local actions = require("diffview.actions")

		local hunk_next = function() vim.cmd("normal! ]c") end
		local hunk_prev = function() vim.cmd("normal! [c") end

		require("diffview").setup({
			keymaps = {
				disable_defaults = false,
				view = {
					{ "n", "]h", hunk_next, { desc = "Jump to next hunk" } },
					{ "n", "[h", hunk_prev, { desc = "Jump to previous hunk" } },
				},
				diff1 = {
					{ "n", "]h", hunk_next, { desc = "Jump to next hunk" } },
					{ "n", "[h", hunk_prev, { desc = "Jump to previous hunk" } },
				},
				diff2 = {
					{ "n", "]h", hunk_next, { desc = "Jump to next hunk" } },
					{ "n", "[h", hunk_prev, { desc = "Jump to previous hunk" } },
				},
				diff3 = {
					{ "n", "]h",           hunk_next,                            { desc = "Jump to next hunk" } },
					{ "n", "[h",           hunk_prev,                            { desc = "Jump to previous hunk" } },
					{ "n", "<leader>cl",   actions.conflict_choose("ours"),      { desc = "Choose left (ours) for hunk" } },
					{ "n", "<leader>cr",   actions.conflict_choose("theirs"),    { desc = "Choose right (theirs) for hunk" } },
					{ "n", "<leader>cb",   actions.conflict_choose("all"),       { desc = "Choose both for hunk" } },
					{ "n", "<leader>cL",   actions.conflict_choose_all("ours"),  { desc = "Choose left (ours) for file" } },
					{ "n", "<leader>cR",   actions.conflict_choose_all("theirs"),{ desc = "Choose right (theirs) for file" } },
					{ "n", "<leader>cB",   actions.conflict_choose_all("all"),   { desc = "Choose both for file" } },
				},
				diff4 = {
					{ "n", "]h",           hunk_next,                            { desc = "Jump to next hunk" } },
					{ "n", "[h",           hunk_prev,                            { desc = "Jump to previous hunk" } },
					{ "n", "<leader>cl",   actions.conflict_choose("ours"),      { desc = "Choose left (ours) for hunk" } },
					{ "n", "<leader>cr",   actions.conflict_choose("theirs"),    { desc = "Choose right (theirs) for hunk" } },
					{ "n", "<leader>cb",   actions.conflict_choose("all"),       { desc = "Choose both for hunk" } },
					{ "n", "<leader>cL",   actions.conflict_choose_all("ours"),  { desc = "Choose left (ours) for file" } },
					{ "n", "<leader>cR",   actions.conflict_choose_all("theirs"),{ desc = "Choose right (theirs) for file" } },
					{ "n", "<leader>cB",   actions.conflict_choose_all("all"),   { desc = "Choose both for file" } },
				},
			},
		})
	end,
}
