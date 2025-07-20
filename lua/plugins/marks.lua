return {
	"chentoast/marks.nvim",
	event = "VeryLazy",
	opts = {
		excluded_buftypes = { "prompt" },
		default_mappings = false,
		mappings = {
			set_next = "<leader>m,",
			toggle = "<leader>mt",
			set = "<leader>ma",
			delete = "<leader>md",
			delete_line = "<leader>mld",
			delete_buf = "<leader>mbd",
			annotate = "<leader>mn",

			next = "]m",
			prev = "[m",

			preview = "<leader>m:",

			-- Set bookmarks
			set_bookmark0 = "<leader>m0",
			set_bookmark1 = "<leader>m1",
			set_bookmark2 = "<leader>m2",
			set_bookmark3 = "<leader>m3",
			set_bookmark4 = "<leader>m4",
			set_bookmark5 = "<leader>m5",
			set_bookmark6 = "<leader>m6",
			set_bookmark7 = "<leader>m7",
			set_bookmark8 = "<leader>m8",
			set_bookmark9 = "<leader>m9",
		},
	},
	keys = {
		{
			"n",
			"<leader>mgqf",
			"<CMD>MarksQFListAll<CR>",
			{ desc = "List all [m]arks [g]lobally in [q]uick[f]ix list" },
		},
		{
			"n",
			"<leader>mbqf",
			"<CMD>MarksQFListBuf<CR>",
			{ desc = "List all [m]arks in [b]uffer in [q]uick[f]ix list" },
		},
	},
}
