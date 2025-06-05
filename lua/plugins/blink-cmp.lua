return {
	"saghen/blink.cmp",
	enable = false,
	-- optional: provides snippets for the snippet source
	dependencies = {
		"rafamadriz/friendly-snippets",
		"mikavilpas/blink-ripgrep.nvim",
		"neovim/nvim-lspconfig",
		"folke/snacks.nvim",
		{ "nvim-tree/nvim-web-devicons", opts = {} },
		{ "echasnovski/mini.nvim" },
	},

	-- use a release tag to download pre-built binaries
	version = "1.*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
		-- 'super-tab' for mappings similar to vscode (tab to accept)
		-- 'enter' for enter to accept
		-- 'none' for no mappings
		--
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		--
		-- See :h blink-cmp-config-keymap for defining your own keymap
		keymap = {
			preset = "none",

			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<Tab>"] = {
				function(cmp)
					if not cmp.get_selected_item() == nil then
						return cmp.accept({ index = 0 })
					end
					return cmp.accept()
				end,
				"fallback",
			},
			["<S-Tab>"] = { "snippet_backward", "fallback" },
			["<CR>"] = {
				function(cmp)
					if cmp.get_selected_item() == nil then
						return false
					end
					return cmp.accept()
				end,
				"fallback",
			},

			["K"] = { "show_signature", "hide_signature", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
		},

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		-- (Default) Only show the documentation popup when manually triggered
		completion = {
			documentation = { auto_show = false },

			-- ghost_text = { enabled = true },
		},

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = {
				"lsp",
				"snippets",
				"path",
				"buffer",
				"ripgrep",
			},
			providers = {
				lsp = {
					name = "lsp",
					enabled = true,
					module = "blink.cmp.sources.lsp",
					score_offset = 90,

					transform_items = function(_, items)
						for _, item in ipairs(items) do
							item.kind_icon = "🇱"
							item.kind_name = "LSP"
						end
						return items
					end,
				},

				ripgrep = {
					module = "blink-ripgrep",
					name = "Ripgrep",
					-- the options below are optional, some default values are shown
					---@module "blink-ripgrep"
					---@type blink-ripgrep.Options
					opts = {
						-- For many options, see `rg --help` for an exact description of
						-- the values that ripgrep expects.
						prefix_min_len = 3,

						-- The number of lines to show before and after each match in the preview
						context_size = 3,

						-- The maximum file size of a file that ripgrep should include in
						-- its search. Useful when your project contains large files that
						-- might cause performance issues.
						-- Examples:
						-- "1024" (bytes by default), "200K", "1M", "1G", which will
						-- exclude files larger than that size.
						max_filesize = "1M",

						-- Specifies how to find the root of the project where the ripgrep
						-- search will start from. Accepts the same options as the marker
						-- given to `:h vim.fs.root()` which offers many possibilities for
						-- configuration. If none can be found, defaults to Neovim's cwd.
						--
						-- Examples:
						-- - ".git" (default)
						-- - { ".git", "package.json", ".root" }
						project_root_marker = { ".git", ".plzconfig" },

						-- Enable fallback to neovim cwd if project_root_marker is not
						-- found. Default: `true`, which means to use the cwd.
						project_root_fallback = true,

						-- The casing to use for the search in a format that ripgrep
						-- accepts. Defaults to "--ignore-case". See `rg --help` for all the
						-- available options ripgrep supports, but you can try
						-- "--case-sensitive" or "--smart-case".
						search_casing = "--smart-case",

						-- When a result is found for a file whose filetype does not have a
						-- treesitter parser installed, fall back to regex based highlighting
						-- that is bundled in Neovim.
						fallback_to_regex_highlighting = true,

						-- Absolute root paths where the rg command will not be executed.
						-- Usually you want to exclude paths using gitignore files or
						-- ripgrep specific ignore files, but this can be used to only
						-- ignore the paths in blink-ripgrep.nvim, maintaining the ability
						-- to use ripgrep for those paths on the command line. If you need
						-- to find out where the searches are executed, enable `debug` and
						-- look at `:messages`.
						ignore_paths = {},

						-- Requires folke/snacks.nvim.
						toggles = {
							-- The keymap to toggle the plugin on and off from blink
							-- completion results. Example: "<leader>tg"
							on_off = "<leader>cmprg",
						},

						-- Features that are not yet stable and might change in the future.
						-- You can enable these to try them out beforehand, but be aware
						-- that they might change. Nothing is enabled by default.
						future_features = {
							backend = {
								-- Available options:
								-- - "ripgrep", always use ripgrep
								-- - "gitgrep", always use git grep
								-- - "gitgrep-or-ripgrep", use git grep if possible, otherwise
								--   ripgrep
								use = "gitgrep-or-ripgrep",
							},
						},

						-- Show debug information in `:messages` that can help in
						-- diagnosing issues with the plugin.
						debug = false,
					},
					-- (optional) customize how the results are displayed. Many options
					-- are available - make sure your lua LSP is set up so you get
					-- autocompletion help
					transform_items = function(_, items)
						for _, item in ipairs(items) do
							-- example: append a description to easily distinguish rg results
							item.kind_icon = "🔍"
							item.kind_name = "ripgrep"
						end
						return items
					end,
				},

				signature = {
					name = "signature",
					module = "blink.cmp.signature",
					enabled = true,
					transform_items = function(_, items)
						for _, item in ipairs(items) do
							item.kind_icon = "✍️"
							item.kind_name = "signature"
						end
						return items
					end,
				},

				snippets = {
					name = "snippets",
					enabled = true,
					max_items = 15,
					min_keyword_length = 2,
					module = "blink.cmp.sources.snippets",
					score_offset = 60, -- the higher the number, the higher the priority

					transform_items = function(_, items)
						for _, item in ipairs(items) do
							item.kind_icon = "✂️"
							item.kind_name = "snippet"
						end

						-- NOTE: After the transformation, I have to reload the snippets source
						vim.schedule(function()
							require("blink.cmp").reload("snippets")
						end)
						return items
					end,
				},

				buffer = {
					transform_items = function(_, items)
						for _, item in ipairs(items) do
							item.kind_icon = "⬛"
							item.kind_name = "buffer"
						end

						-- NOTE: After the transformation, I have to reload the snippets source
						vim.schedule(function()
							require("blink.cmp").reload("snippets")
						end)
						return items
					end,
				},

				path = {
					transform_items = function(_, items)
						for _, item in ipairs(items) do
							item.kind_icon = "📂"
							item.kind_name = "path"
						end

						-- NOTE: After the transformation, I have to reload the snippets source
						vim.schedule(function()
							require("blink.cmp").reload("snippets")
						end)
						return items
					end,
				},
			},
		},

		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },

	draw = {
		components = {
			kind_icon = {
				ellipsis = false,
				text = function(ctx)
					local icon = ctx.kind_icon
					local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
					if dev_icon then
						icon = dev_icon
					end

					return icon .. ctx.icon_gap
				end,
			},
		},
	},

	cmdline = {
		keymap = { preset = "inherit" },
		completion = { menu = { auto_show = true } },
	},
}
