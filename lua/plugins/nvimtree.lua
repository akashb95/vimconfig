return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", opts = {} },
	},
	lazy = false,
	opts = {
		actions = {
			open_file = {
				resize_window = false,
				quit_on_open = true,
			},
		},
		filters = {
			git_ignored = false,
			custom = {
				".DS_Store$",
			},
		},
		git = {
			timeout = 1000,
		},
		modified = { enable = true },
		renderer = {
			add_trailing = true,
			group_empty = true,
			icons = {
				modified_placement = "before",
				git_placement = "after",
			},
		},
		respect_buf_cwd = true,
		sort_by = "case_sensitive",
		-- sync_root_with_cwd = true,
		update_focused_file = { enable = true },
		view = {
			adaptive_size = true,
		},
	},
}
