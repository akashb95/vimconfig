return {
	"f-person/git-blame.nvim",

	lazy = false,

	opts = {
		enabled = true,
		message_template = " <summary> • <date> • <author>", -- template for the blame message

		date_format = "%d-%m-%Y %H:%M", -- template for the date

		virtual_text_column = 1,
	},
}
