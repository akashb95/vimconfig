-- lazy.nvim
return {
	"chrisgrieser/nvim-origami",
	event = "VeryLazy",
	opts = {}, -- needed even when using default config

	-- recommended: disable vim's auto-folding
	init = function()
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99
	end,
	keys = {
		{
			"z-",
			function()
				vim.opt.foldlevel = vim.opt.foldlevel:get() + 1
			end,
			desc = "Reduce Folding",
		},
		{
			"z+",
			function()
				local current = vim.opt.foldlevel:get()
				if current > 0 then
					vim.opt.foldlevel = current - 1
				end
			end,
			desc = "Increase Folding",
		},
	},
}
