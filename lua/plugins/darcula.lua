function ColourMyPencils(colour)
	colour = colour or "darcula-solid"
	vim.cmd.colorscheme(colour)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
	"briones-gabriel/darcula-solid.nvim",
	dependencies = { "rktjmp/lush.nvim" },

	lazy = false,
	priority = 100,

	config = function()
		vim.cmd("colorscheme darcula-solid")
		vim.cmd("set termguicolors")
		ColourMyPencils("darcula-solid")

		-- darcula-solid uses pre-0.9 treesitter capture names. Link the current
		-- names to the old ones so highlighting still applies.
		local ts_renames = {
			["@string.regexp"]         = "@string.regex",
			["@string.special"]        = "@string.escape",
			["@string.special.symbol"] = "@symbol",
			["@number.float"]          = "@float",
			["@variable.member"]       = "@field",
			["@variable.parameter"]    = "@parameter",
			["@function.method"]       = "@method",
			["@function.method.call"]  = "@method",
			["@module"]                = "@namespace",
			["@keyword.import"]        = "@include",
			["@keyword.conditional"]   = "@conditional",
			["@keyword.repeat"]        = "@repeat",
			["@keyword.exception"]     = "@exception",
			["@markup"]                = "@text",
			["@markup.italic"]         = "@text.emphasis",
			["@markup.underline"]      = "@text.underline",
			["@markup.strikethrough"]  = "@text.strike",
			["@markup.strong"]         = "@text.strong",
			["@markup.heading"]        = "@text.title",
			["@markup.raw"]            = "@text.literal",
			["@markup.link.url"]       = "@text.uri",
		}
		for new, old in pairs(ts_renames) do
			vim.api.nvim_set_hl(0, new, { link = old })
		end
	end,

	opts = {},
}
