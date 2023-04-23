local comment = require("Comment")
local ft = require('Comment.ft')

comment.setup({
	padding = true,

	-- Whether the cursor should stay at its position
	sticky = true,

	mappings = {
		basic = true,
		extra = false,
	},
})

ft({"BUILD", "plz"}, "#%s")
ft({"build_def"}, ft.get("python"))

