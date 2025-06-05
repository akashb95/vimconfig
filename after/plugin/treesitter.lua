local markid = require("markid")

require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all".
	ensure_installed = {
		"c",
		"lua",
		"vim",
		"javascript",
		"typescript",
		"go",
		"rust",
		"python",
		"dart",
		"yaml",
		"json",
		"query",
	},
	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,
	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,
	highlight = {
		enable = true,
		disable = { "c", "rust" },
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		additional_vim_regex_highlighting = false,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "tsn",
			scope_incremental = "n",
			node_decremental = "N",
		},
	},
	indent = { enable = true },
	-- All identifiers with the same name are highlighted in the same colour.
	markid = {
		enable = true,
		colors = markid.colors.dark,
	},
	textobjects = {
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]f"] = "@function.outer",
				["]P"] = "@parameter.outer",
				["]C"] = "@class.outer",
				["]l"] = "@loop.outer",
				["]s"] = "@call.outer",
			},
			goto_previous_start = {
				["[f"] = "@function.outer",
				["[P"] = "@parameter.outer",
				["[C"] = "@class.outer",
				["[l"] = "@loop.outer",
				["[s"] = "@call.outer",
			},
			goto_next_end = {
				[")f"] = "@function.outer",
				[")l"] = "@loop.outer",
			},
			goto_previous_end = {
				["(f"] = "@function.outer",
				["(l"] = "@loop.outer",
			},
		},
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["aP"] = "@parameter.outer",
				["iC"] = "@class.inner",
				["aC"] = "@class.outer",
				["il"] = "@loop.inner",
				["al"] = "@loop.outer",
				["ac"] = "@call.outer",
				["ic"] = "@call.inner",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>nab"] = "@block.outer",
				["<leader>nic"] = "@call.inner",
				["<leader>nac"] = "@call.outer",
				["<leader>naC"] = "@class.outer",
				["<leader>naf"] = "@function.outer",
				["<leader>nil"] = "@literal_value.inner",
				["<leader>nip"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>Nab"] = "@block.outer",
				["<leader>Nic"] = "@call.inner",
				["<leader>Nac"] = "@call.outer",
				["<leader>NaC"] = "@class.outer",
				["<leader>Naf"] = "@function.outer",
				["<leader>Nil"] = "@literal_value.inner",
				["<leader>Nip"] = "@parameter.inner",
			},
		},
	},
})

local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

-- vim way: ; goes to the direction you were moving.
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

-- make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
