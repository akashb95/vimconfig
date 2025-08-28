local util = require("lspconfig.util")

-- Enable the following language servers
--  Add any additional override configuration in the following tables. Available keys are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--  - settings (table): Override the default settings passed when initializing the server.
--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
local servers = {
	yamlls = {},
	vimls = {},
	bashls = {},
	intelephense = {},
	buf_ls = {},
	curlylint = {},
	gopls = {
		settings = {
			gopls = {
				diagnosticsDelay = "2s",
				directoryFilters = { "-plz-out" },
				linksInHover = false,
				-- usePlaceholders = false,
				-- semanticTokens = true,
				codelenses = {
					gc_details = true,
					test = true,
					tidy = true,
					vendor = true,
					regenerate_cgo = true,
					upgrade_dependency = true,
				},
			},
		},
		-- Must be set explicitly. Otherwise breaks on :LspRestart
		single_file = false,
		---@param startpath string
		root_dir = function(startpath)
			if string.find(startpath, "plz%-out") then
				-- Separate branch, because otherwise it defaults to the repo root and becomes too slow
				return require("lspconfig/util").root_pattern("go.mod", "go.work")(startpath)
			else
				return require("lspconfig/util").root_pattern(
					-- Order here matters
					"BUILD",
					"go.work",
					"go.mod",
					".git"
				)(startpath)
			end
		end,
	},
	pyright = {
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
		on_new_config = function(config, root_dir)
			if util.root_pattern(".plzconfig") then
				config.settings = vim.tbl_deep_extend("force", config.settings, {
					python = {
						analysis = {
							extraPaths = {
								vim.fs.joinpath(root_dir, "plz-out/python/venv"),
							},
							exclude = { "plz-out" },
						},
					},
				})
			end
		end,
		root_dir = function()
			return vim.fn.getcwd()
		end,
	},
	pylsp = {
		settings = {
			plugins = {
				pycodestyle = {
					ignore = { "W391" },
					maxLineLength = 120,
					indentSize = 4,
				},
				pydocstyle = {
					convention = "numpy",
				},
			},
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
				-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
				-- diagnostics = { disable = { 'missing-fields' } },
			},
		},
	},
}

-- Ensure the servers and tools above are installed
--  To check the current status of installed tools and/or manually install
--  other tools, you can run
--    :Mason
--
--  You can press `g?` for help in this menu
require("mason").setup()

-- You can add other tools here that you want Mason to install
-- for you, so that they are available from within Neovim.
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
	"stylua", -- Used to format lua code
	{ "black", version = "23.7.0" },
	-- "goimports",
	"prettier",
})
require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

-- LSP servers and clients are able to communicate to each other what features they support.
--  By default, Neovim doesn't support everything that is in the LSP Specification.
--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, vim.lsp.protocol.make_client_capabilities())

local function extend_capabilities(server_name)
	local server = servers[server_name] or {}
	-- This handles overriding only values explicitly passed
	-- by the server configuration above. Useful when disabling
	-- certain features of an LSP (for example, turning off formatting for tsserver)
	server.capabilities = require("blink.cmp").get_lsp_capabilities(server.capabilities)
	server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
	require("lspconfig")[server_name].setup(server)
end

-- mason-lspconfig.nvim will automatically enable (vim.lsp.enable()) installed servers for you by default.
require("mason-lspconfig").setup({
	automatic_enable = {
		exclude = {
			"gopls",
		},
	},
	handlers = { extend_capabilities },
})

-- Defines and sets up the the please language server (this is the only one that is not inlcuded in lspconfig.configs by
-- default, and is also not included in mason)
require("lspconfig.configs").please = {
	default_config = {
		cmd = { "plz", "tool", "lps" },
		filetypes = { "please" },
		root_dir = util.root_pattern(".plzconfig"),
	},
}
require("lspconfig").please.setup({})

-- For some reason, setting this up via mason-lspconfig doesn't work. Setup gopls manually.
extend_capabilities("gopls")
require("lspconfig").gopls.setup(servers.gopls)
