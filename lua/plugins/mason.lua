return {
	-- 'williamboman/mason-tool-installer.nvim',
	"williamboman/mason.nvim",
	-- dependencies = { 'williamboman/mason.nvim' },
	opts = {
		ensure_installed = {
			"lua_ls",
			"rust_analyzer",
			"gopls",
			"pylsp",
			"buf",
			"sqlls",
			"jsonls",
			"bashls",
			"yamlls",

			-- Formatters
			"stylua", -- Used to format lua code
			{ "black", version = "23.7.0" },
		},
	},
}
