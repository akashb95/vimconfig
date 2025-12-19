return {
	"f-person/git-blame.nvim",

	lazy = false,

	keys = {
		{ "<leader>gburl", "<CMD>GitBlameOpenCommitURL<CR>", desc = "[g]it [b]lame open commit [url]" },
	},
	keys = {
		{ "<leader>gbcurl", "<CMD>GitBlameCopyCommitURL<CR>", desc = "[g]it [b]lame [c]opy commit [url]" },
	},

	opts = {
		enabled = true,
		message_template = " <date> • <author> • <summary>", -- template for the blame message

		date_format = "%r", -- template for the date
		max_commit_summary_length = 50,

		virtual_text_column = 1,
	},
}
