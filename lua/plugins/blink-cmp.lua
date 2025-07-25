return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = {
		"rafamadriz/friendly-snippets",
		"mikavilpas/blink-ripgrep.nvim",
		"neovim/nvim-lspconfig", -- Provides useful utility function
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
		enabled = function()
			-- Disable in comments
			local row, column = unpack(vim.api.nvim_win_get_cursor(0))
			local success, node = pcall(vim.treesitter.get_node, {
				pos = { row - 1, math.max(0, column - 1) },
				ignore_injections = false,
			})
			local reject =
				{ "comment", "line_comment", "block_comment", "string_start", "string_content", "string_end" }
			if success and node and vim.tbl_contains(reject, node:type()) then
				return false
			end

			-- Disable in rename, NerdTree and prompts in general.
			return not vim.list_contains({ "DressingInput" }, vim.bo.filetype)
				and vim.bo.buftype ~= "prompt"
				and vim.b.completion ~= false
		end,
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
			["<BS>"] = {
				function() end,
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

			kind_icons = {
				Text = "T",
				Method = "𝓂",
				Function = "ƒ",
				Constructor = "🏗️",

				Field = ".f",
				Variable = "var",
				Property = "𝐏",

				Class = "𝒞",
				Interface = "🧩",
				Struct = "{}",
				Module = "📦",

				Unit = "u",
				Value = "v",
				Enum = "enum",
				EnumMember = "▫",

				Keyword = "🔑",
				Constant = "с",

				Snippet = "✂️",
				Color = "🎨",
				File = "📄",
				Reference = "જ⁀➴",
				Folder = "📁",
				Event = "📣",
				Operator = "⦻",
				TypeParameter = "𝐓",
			},
		},

		completion = {
			documentation = { auto_show = false },

			-- ghost_text = { enabled = true },
			menu = {
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
			},
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
					max_items = 25,
					enabled = true,
					module = "blink.cmp.sources.lsp",
					score_offset = 90,
				},

				ripgrep = {
					module = "blink-ripgrep",
					max_items = 3,
					name = "Ripgrep",
					-- the options below are optional, some default values are shown
					---@module "blink-ripgrep"
					---@type blink-ripgrep.Options
					opts = {
						-- For many options, see `rg --help` for an exact description of
						-- the values that ripgrep expects.
						prefix_min_len = 4,

						-- The number of lines to show before and after each match in the preview
						context_size = 3,

						-- The maximum file size of a file that ripgrep should include in
						-- its search. Useful when your project contains large files that
						-- might cause performance issues.
						-- Examples:
						-- "1024" (bytes by default), "200K", "1M", "1G", which will
						-- exclude files larger than that size.
						max_filesize = "500K",

						-- Specifies how to find the root of the project where the ripgrep
						-- search will start from. Accepts the same options as the marker
						-- given to `:h vim.fs.root()` which offers many possibilities for
						-- configuration. If none can be found, defaults to Neovim's cwd.
						--
						-- Examples:
						-- - ".git" (default)
						-- - { ".git", "package.json", ".root" }
						project_root_marker = { ".git", ".plzconfig", "go.mod", "requirements.txt" },

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
						ignore_paths = { "**/plz-out" },

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
								use = "ripgrep",
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

				snippets = {
					name = "snippets",
					enabled = true,
					max_items = 5,
					min_keyword_length = 2,
					module = "blink.cmp.sources.snippets",
					score_offset = 70, -- the higher the number, the higher the priority

					transform_items = function(_, items)
						for _, item in ipairs(items) do
							item.kind_icon = "✂️"
							item.kind_name = "snippet"
						end
						return items
					end,
				},

				buffer = {
					max_items = 3,
					transform_items = function(_, items)
						for _, item in ipairs(items) do
							item.kind_icon = "⬛"
							item.kind_name = "buffer"
						end
						return items
					end,
				},

				path = {
					max_items = 2,
					transform_items = function(_, items)
						for _, item in ipairs(items) do
							item.kind_icon = "📂"
							item.kind_name = "path"
						end
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

	cmdline = {
		keymap = { preset = "inherit" },
		completion = { menu = { auto_show = true } },
	},
}
