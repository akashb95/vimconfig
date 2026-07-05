return {
	"monkoose/matchparen.nvim",
	lazy = false,
	config = function()
		require("matchparen").setup({
			enabled = true,
			hl_group = "MatchParen",
		})
	end,
}
