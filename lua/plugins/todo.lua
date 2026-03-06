return {
	"folke/todo-comments.nvim",
	opts = {
		keywords = {
			FIX = { icon = "🔧", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
			TODO = { icon = "🕐", color = "info" },
			HACK = { icon = "🩹", color = "warning" },
			WARN = { icon = "🟥", color = "warning", alt = { "WARNING", "XXX" } },
			PERF = { icon = "🏃", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
			NOTE = { icon = "🔖", color = "hint", alt = { "INFO" } },
			TEST = { icon = "🧪", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
			TRACE = { icon = "🔍", color = "warning", alt = { "TRACK", "INVESTIGATION" } },
		},
		signs = true, -- show icons in the signs column
		sign_priority = 8, -- sign priority
		gui_style = { fg = "BOLD", bg = "BOLD" },
		merge_keywords = true, -- when true, custom keywords will be merged with the defaults
		-- highlighting of the line containing the todo comment
		-- * before: highlights before the keyword (typically comment characters)
		-- * keyword: highlights of the keyword
		-- * after: highlights after the keyword (todo text)
		highlight = {
			multiline = true,
			multiline_pattern = "^.",
			multiline_context = 15,
			before = "fg",
			keyword = "bg",
			after = "fg",
			pattern = [[.*<(KEYWORDS)\s*(\(.*\))?:]],
			comments_only = true, -- uses treesitter to match keywords in comments only
			max_line_len = 200,
			exclude = {},
		},
		-- list of named colors where we try to extract the guifg from the
		-- list of highlight groups or use the hex color if hl not found as a fallback
		colors = {
			error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
			warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
			info = { "DiagnosticInfo", "#0D2A6B" },
			hint = { "DiagnosticHint", "#10B981" },
			default = { "Identifier", "#7C3AED" },
			test = { "Identifier", "#FF00FF" },
		},
		search = {
			command = "rg",
			args = {
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
			},
			-- regex that will be used to match keywords.
			-- don't replace the (KEYWORDS) placeholder
			pattern = [[\b(KEYWORDS):]], -- ripgrep regex
		},
	},
	config = function(_, opts)
		local todo = require("todo-comments")
		todo.setup(opts)

		vim.keymap.set("n", "]t", function()
			todo.jump_next({ keywords = { "FIXME", "TRACE", "TODO" } })
		end, { desc = "Next trace comment" })

		vim.keymap.set("n", "[t", function()
			todo.jump_prev({ keywords = { "FIXME", "TRACE", "TODO" } })
		end, { desc = "Previous trace comment" })
	end,
}
