return {
	"f-person/git-blame.nvim",

	event = { "BufReadPost", "BufNewFile" },

	keys = {
		{
			"<leader>gbt",
			"<CMD>GitBlameToggle<CR>",
			desc = "[g]it [b]lame [t]oggle",
		},
		{
			"<leader>gbocurl" --[[  ]],
			"<CMD>GitBlameOpenCommitURL<CR>",
			desc = "[g]it [b]lame [o]pen [c]ommit [url]",
		},
		{
			"<leader>gbcurl",
			"<CMD>[GitBlameCopyCommitURL<CR>",
			desc = "[g]it [b]lame [c]opy commit [url]",
		},
	},

	opts = {
		enabled = true,
		message_template = "<date> • <author> • <summary>",
		date_format = "%r",
		max_commit_summary_length = 50,
		virtual_text_column = 1,

		delay = 250,

		ignored_filetypes = { "help", "NvimTree" },
	},
}
