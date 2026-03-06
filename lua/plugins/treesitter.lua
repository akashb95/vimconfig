return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-context", opts = { max_lines = 3 } },
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		local markid = require("markid")

		require("nvim-treesitter.configs").setup({
			-- Consolidating the parser lists from both your files
			ensure_installed = {
				"bash",
				"c",
				"comment",
				"dart",
				"git_config",
				"git_rebase",
				"gitcommit",
				"gitignore",
				"go",
				"gomod",
				"gosum",
				"gowork",
				"html",
				"java",
				"javascript",
				"jinja",
				"json",
				"lua",
				"make",
				"markdown",
				"promql",
				"proto",
				"python",
				"query",
				"regex",
				"ruby",
				"rust",
				"scheme",
				"sql",
				"ssh_config",
				"toml",
				"typescript",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
			},
			sync_install = false,
			auto_install = true,

			highlight = {
				enable = true,
				disable = { "c", "rust" },
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "tsn",
					scope_incremental = "n",
					node_decremental = "N",
				},
			},

			markid = {
				enable = true,
				colors = markid.colors.dark,
			},

			textobjects = {
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]as"] = "@assignment.outer",
						["]at"] = "@attribute.outer",
						["]b"] = "@block.outer",
						["]ca"] = "@call.outer",
						["]C"] = "@class.outer",
						["]cm"] = "@comment.outer",
						["]cn"] = "@conditional.outer",
						["]f"] = "@function.outer",
						["]l"] = "@loop.outer",
						["]p"] = "@parameter.outer",
						["]st"] = "@statement.outer",
					},
					goto_previous_start = {
						["[as"] = "@assignment.outer",
						["[at"] = "@attribute.outer",
						["[b"] = "@block.outer",
						["[ca"] = "@call.outer",
						["[C"] = "@class.outer",
						["[cm"] = "@comment.outer",
						["[cn"] = "@conditional.outer",
						["[f"] = "@function.outer",
						["[l"] = "@loop.outer",
						["[p"] = "@parameter.outer",
						["[st"] = "@statement.outer",
					},
				},
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["as"] = "@assignment.outer",
						["is"] = "@assignment.inner",
						["aca"] = "@call.outer",
						["ica"] = "@call.inner",
						["iC"] = "@class.inner",
						["aC"] = "@class.outer",
						["acn"] = "@conditional.outer",
						["icn"] = "@conditional.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["aP"] = "@parameter.outer",
						["il"] = "@loop.inner",
						["al"] = "@loop.outer",
						["ast"] = "@statement.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>naC"] = "@class.outer",
						["<leader>naf"] = "@function.outer",
						["<leader>nil"] = "@literal_value.inner",
						["<leader>nip"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>NaC"] = "@class.outer",
						["<leader>Naf"] = "@function.outer",
						["<leader>Nil"] = "@literal_value.inner",
						["<leader>Nip"] = "@parameter.inner",
					},
				},
			},
		})

		-- Configure repeatable textobject motions
		local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
		vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
		vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

		-- Make f, F, t, T also repeatable with ; and ,
		vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
		vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
		vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
		vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
	end,
}
