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
	},
	---@type YaziConfig | {}
	opts = {
		open_for_directories = true,
		change_neovim_cwd_on_close = false,
		open_multiple_tabs = true,
		yazi_floating_window_winblend = 20,
		keymaps = {
			show_help = "?",
		},
		future_features = {
			use_cwd_file = true,
			new_shell_escaping = true,
		},
	},
	init = function()
		-- mark netrw as loaded so it's not loaded at all.
		-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
		vim.g.loaded_netrwPlugin = 1
	end,
}
