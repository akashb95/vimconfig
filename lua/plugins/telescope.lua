return {
	"nvim-telescope/telescope.nvim", -- Fuzzy Finder (files, LSP, etc)
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			-- `build` is used to run some command when the plugin is installed/updated.
			-- This is only run then, not every time Neovim starts up.
			build = "make",
		},
		{
			"nvim-telescope/telescope-live-grep-args.nvim",
			version = "1.1.0",
		},
		{
			"nvim-tree/nvim-web-devicons",
		},
	},
}
