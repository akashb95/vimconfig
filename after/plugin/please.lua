local please = require("please")
local wk = require("which-key")

wk.register({
	["<leader>p"] = {
		name = "Please",
		b = {
			please.build,
			"Build",
		},
		j = { please.jump_to_target, "Jump to BUILD target" },
		r = { require("please.runners.popup").restore, "Restore popup" },
		t = {
			function() please.test({under_cursor = true}) end,
			"Test under cursor",
		},
		y = {
			please.yank, "Yank target name, or name of target which takes current file in buffer as input"
		}
	},
})
