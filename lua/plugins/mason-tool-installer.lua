return {
	"WhoIsSethDaniel/mason-tool-installer.nvim", -- ensures that LSPs and formatters are installed when opening neovim for the first time.
	dependencies = {
		"neovim/nvim-lspconfig", -- LSP Configuration & Plugins
		"williamboman/mason.nvim", -- installing LSPs and code formatters
		"williamboman/mason-lspconfig.nvim", -- provides mappings between lspconfig and mason
		"saghen/blink.cmp",

		-- Useful status updates for LSP.
		{ "j-hui/fidget.nvim", opts = {} },

		-- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim APIs
		{ "folke/neodev.nvim", opts = {} },
	},
}
