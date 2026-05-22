return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-context", opts = { max_lines = 3 } },
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		require("nvim-treesitter").install({
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
			"markdown_inline",
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
		})

		-- Enable treesitter highlighting and indentation via FileType autocmd
		local disabled_ft = { c = true, rust = true }
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(ev)
				if disabled_ft[vim.bo[ev.buf].filetype] then
					return
				end
				local ok = pcall(vim.treesitter.start, ev.buf)
				if ok then
					vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})

		-- Textobjects: options (keymaps are set explicitly below)
		require("nvim-treesitter-textobjects").setup({
			select = { lookahead = true },
			move = { set_jumps = true },
		})

		-- Select
		local sel = require("nvim-treesitter-textobjects.select")
		local select_maps = {
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
		}
		for key, query in pairs(select_maps) do
			vim.keymap.set({ "x", "o" }, key, function()
				sel.select_textobject(query, "textobjects")
			end)
		end

		-- Move
		local mv = require("nvim-treesitter-textobjects.move")
		local next_start = {
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
		}
		local prev_start = {
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
		}
		for key, query in pairs(next_start) do
			vim.keymap.set({ "n", "x", "o" }, key, function()
				mv.goto_next_start(query, "textobjects")
			end)
		end
		for key, query in pairs(prev_start) do
			vim.keymap.set({ "n", "x", "o" }, key, function()
				mv.goto_previous_start(query, "textobjects")
			end)
		end

		-- Swap
		local sw = require("nvim-treesitter-textobjects.swap")
		vim.keymap.set("n", "<leader>naC", function() sw.swap_next("@class.outer") end)
		vim.keymap.set("n", "<leader>naf", function() sw.swap_next("@function.outer") end)
		vim.keymap.set("n", "<leader>nil", function() sw.swap_next("@literal_value.inner") end)
		vim.keymap.set("n", "<leader>nip", function() sw.swap_next("@parameter.inner") end)
		vim.keymap.set("n", "<leader>NaC", function() sw.swap_previous("@class.outer") end)
		vim.keymap.set("n", "<leader>Naf", function() sw.swap_previous("@function.outer") end)
		vim.keymap.set("n", "<leader>Nil", function() sw.swap_previous("@literal_value.inner") end)
		vim.keymap.set("n", "<leader>Nip", function() sw.swap_previous("@parameter.inner") end)

		-- Repeatable f/t/;/, motions
		local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
		vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
		vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
		vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
	end,
}
