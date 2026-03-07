return {
	"luukvbaal/statuscol.nvim",
	event = "VeryLazy",
	config = function()
		local builtin = require("statuscol.builtin")

		vim.opt.fillchars:append({
			fold = " ",
			foldclose = "▸",
			foldopen = "▾",
			foldsep = " ",
		})

		require("statuscol").setup({
			relculright = true,
			segments = {
				-- Fold column: exactly 1 char wide, clickable
				{ text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },

				-- Git signs: exactly 1 char wide, only shows when present
				{
					sign = { namespace = { "gitsigns" }, maxwidth = 1, colwidth = 1, auto = false },
					click = "v:lua.ScSa",
				},

				{
					sign = { namespace = { "diagnostic/signs" }, maxwidth = 1, colwidth = 1, auto = false },
					click = "v:lua.ScSa",
				},

				-- Fallback for other signs (like DAP breakpoints)
				{
					sign = { name = { ".*" }, maxwidth = 1, colwidth = 1, auto = false },
					click = "v:lua.ScSa",
				},

				-- Line numbers
				{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
			},
		})
	end,
}
