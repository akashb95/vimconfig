---@type LazySpec
return {
	"mikavilpas/yazi.nvim",
	version = "*", -- use the latest stable version
	event = "VeryLazy",
	dependencies = {
		{ "nvim-lua/plenary.nvim", lazy = true },
	},
	keys = {
		{
			"<leader>e",
			mode = { "n", "v" },
			"<cmd>Yazi<cr>",
			desc = "Open yazi at the current file",
		},
		{
			-- Open in the current working directory
			"<leader>E",
			"<cmd>Yazi cwd<cr>",
			desc = "Open the file manager in nvim's working directory",
		},
		{
			"<C-e>",
			"<cmd>Yazi toggle<cr>",
			desc = "Resume the last yazi session",
		},
	},
	---@type YaziConfig | {}
	opts = {
		-- if you want to open yazi instead of netrw, see below for more info
		open_for_directories = true,
		keymaps = {
			show_help = "<f1>",
		},
		future_features = {
			-- use a file to store the last directory that yazi was in before it was
			-- closed. Defaults to `true`.
			use_cwd_file = true,

			-- use a new shell escaping implementation that is more robust and works
			-- on more platforms. Defaults to `true`. If set to `false`, the old
			-- shell escaping implementation will be used, which is less robust and
			-- may not work on all platforms.
			new_shell_escaping = true,
		},
	},
	init = function()
		-- mark netrw as loaded so it's not loaded at all.
		-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
		vim.g.loaded_netrwPlugin = 1
	end,
}
