-- Enable the following language servers
--  Add any additional override configuration in the following tables. Available keys are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--  - settings (table): Override the default settings passed when initializing the server.
--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
--  - root_dir (function): Dynamically determine whether to enable LSP given the buffer number.
local servers = {
	yamlls = {},
	vimls = {},
	bashls = {},
	intelephense = {},
	buf_ls = {},
	curlylint = {},
	gopls = {
		cmd = { "gopls" },
		settings = {
			gopls = {
				codelenses = {
					gc_details = true,
					test = true,
					tidy = true,
					vendor = true,
					regenerate_cgo = true,
					upgrade_dependency = true,
				},
				diagnosticsDelay = "2s",
				directoryFilters = { "-plz-out" },
				linksInHover = false,
			},
		},
		-- Must be set explicitly. Otherwise breaks on :LspRestart
		single_file = false,
		---@param buffer integer
		-- @param on_dir function(root_dir?:string)
		root_dir = function(buffer, on_dir)
			local buffer_name = vim.api.nvim_buf_get_name(buffer)

			local root

			-- plz-out is where Please stores its artifacts.
			if string.find(buffer_name, "plz%-out") then
				-- Separate branch, because otherwise it defaults to the repo root and becomes too slow
				root = vim.fs.dirname(vim.fs.find({ "go.mod", "go.work" }, { upward = true, type = "file" })[1])
			end

			root = vim.fs.dirname(vim.fs.find({
				-- Order here matters
				"BUILD",
				"go.work",
				"go.mod",
				".git",
			}, { upward = true, type = "file" })[1])

			if not root then
				-- Default to cwd.
				root = vim.fs.dirname(buffer_name)
			end

			on_dir(root)
		end,
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
	pyright = {
		settings = {
			python = {
				analysis = {
					autoSearchPaths = true,
					typeCheckingMode = "standard",
					verboseOutput = true,
					logLevel = "Trace",
					extraPaths = {
						"plz-out/gen",
						"plz-out/python/venv",
					},
					exclude = { "plz-out" },
				},
			},
		},
		---@param buffer integer
		-- @param on_dir function(root_dir?:string)
		root_dir = function(buffer, on_dir)
			on_dir(vim.fs.dirname(vim.api.nvim_buf_get_name(buffer)))
		end,
	},
	rust_analyzer = {},
	sqlls = {},
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
vim.list_extend(vim.tbl_keys(servers or {}), {
	"stylua", -- Used to format lua code
	{ "black", version = "23.7.0" },
	"pylint",
	-- "goimports",
	"prettier",
})
require("mason-tool-installer").setup({ ensure_installed = vim.tbl_keys(servers or {}) })

local function extend_capabilities_and_setup(server_name, server_config)
	-- LSP servers and clients are able to communicate to each other what features they support.
	--  By default, Neovim doesn't support everything that is in the LSP Specification.
	--  When you add blink-cmp, luasnip, etc. Neovim now has *more* capabilities.
	--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
	-- This also handles overriding only values explicitly passed
	-- by the server configuration above. Useful when disabling
	-- certain features of an LSP (for example, turning off formatting for tsserver)

	local blink_cmp_capabilities = {}
	local blink_cmp_import_success, blink_cmp = pcall(require, "blink.cmp")
	if blink_cmp_import_success then
		blink_cmp_capabilities = blink_cmp.get_lsp_capabilities(server_config.capabilities)
	end

	server_config.capabilities = vim.tbl_deep_extend("force", {
		-- Some LSPs need to be told line-folding is allowed (e.g. yamlls).
		-- No harm in letting all LSPs know.
		capabilities = {
			textDocument = {
				foldingRange = {
					dynamicRegistration = false,
					lineFoldingOnly = true,
				},
			},
		},
	}, blink_cmp_capabilities, server_config.capabilities or {})

	vim.lsp.enable(server_name, vim.lsp.config(server_name, server_config))
end

for server_name, server_config in pairs(servers) do
	extend_capabilities_and_setup(server_name, server_config)
end

-- Configure Please LSP separately so that Mason doesn't try to install it.
vim.lsp.enable(
	"please",
	vim.lsp.config("please", {
		cmd = { "plz", "tool", "lps" },
		filetypes = { "please" },
		---@param buffer integer
		-- @param on_dir function(root_dir?:string)
		root_dir = function(_, on_dir)
			on_dir(vim.fs.dirname(vim.fs.find({ ".plzconfig" }, { upward = true, type = "file" })[1]))
		end,
	})
)

-- TODO: delete after confirming vim.lsp config works
-- Defines and sets up the the please language server (this is the only one that is not inlcuded in lspconfig.configs by
-- default, and is also not included in mason)
-- require("lspconfig.configs").please = {
-- 	default_config = {
-- 		cmd = { "plz", "tool", "lps" },
-- 		filetypes = { "please" },
-- 		root_dir = util.root_pattern(".plzconfig"),
-- 	},
-- }
-- require("lspconfig").please.setup({})
