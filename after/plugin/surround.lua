local surround = require("nvim-surround")
local wk = require("which-key")

surround.setup({})

wk.register({
	cs = {"Change surrounding characters."},
	ds = {"Delete around"},
	dsf = {"Delete function calls"},
})
