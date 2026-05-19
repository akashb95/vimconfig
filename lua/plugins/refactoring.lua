return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"lewis6991/async.nvim",
	},
	lazy = false,
	opts = {},
	config = function(_, opts)
		local refactoring = require("refactoring")

		refactoring.setup(opts)

		vim.keymap.set({ "n", "x" }, "<leader>rs", function()
			-- this keymap doesn't select any textobject by default, so you may need to provide one each time you use it.
			refactoring.select_refactor()
		end, { desc = "[r]efactor [s]elect" })
	end,
}
