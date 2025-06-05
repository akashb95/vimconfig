local lspconfig_util = require("lspconfig.util")

return {
	cmd = { "pylsp" },
	filetypes = { "py" },
	root_dir = function(fname)
		local plz_root = lspconfig_util.root_pattern(".plzconfig")(fname)
		return plz_root
	end,
	single_file_support = false,
	settings = {
		pylsp = {
			plugins = {
				pycodestyle = {
					ignore = { "W391" },
					maxLineLength = 100,
				},
			},
		},
	},
}
