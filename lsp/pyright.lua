local lspconfig_util = require("lspconfig.util")

return {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = {
		".plzconfig",
		"setup.py",
		"requirements.txt",
		".git",
	},
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				typeCheckingMode = "standard",
				verboseOutput = true,
				logLevel = "Trace",
				extraPaths = {
					"plz_out/gen",
					"plz-out/gen",
					"plz-out/python/venv",
				},
			},
		},
	},
}
