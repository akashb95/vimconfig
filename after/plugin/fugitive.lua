local wk = require("which-key")

wk.register({
	["<leader>gs"] = {
		name = "Git",
		t = { vim.cmd.Git, "Show status in new pane" }
	},
})
