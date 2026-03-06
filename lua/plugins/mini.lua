return {
	"echasnovski/mini.nvim", -- Collection of various small independent plugins/modules
	config = function()
		-- Better Around/Inside textobjects
		--
		-- Examples:
		--  - va)  - [V]isually select [A]round [)]paren
		--  - yinq - [Y]ank [I]nside [N]ext [']quote
		--  - ci'  - [C]hange [I]nside [']quote
		require("mini.ai").setup({ n_lines = 500 })

		-- Some custom operators
		require("mini.operators").setup({
			evaluate = { prefix = "" },
			exchange = { prefix = "" },
			multiply = { prefix = "" },
			replace = { prefix = "<leader>r" },
			sort = { prefix = "<leader>s" },
		})

		-- Add/delete/replace surroundings (brackets, quotes, etc.)
		--
		-- - saiw) - [s]urround [a]dd [i]nner [w]ord [)]Paren
		-- - sd'   - [s]urround [d]elete [']quotes
		-- - sr)'  - [s]urround [r]eplace [)] [']
		require("mini.surround").setup()
	end,
}
