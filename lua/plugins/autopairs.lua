return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = true,
	disable_filetype = { "TelescopePrompt" },

	-- use opts = {} for passing setup options
	-- this is equivalent to setup({}) function
	opts = {
		check_ts = true,
		-- map_cr = true,
	},
}
