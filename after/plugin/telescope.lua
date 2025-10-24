local telescope = require("telescope")
local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
local builtin = require("telescope.builtin")

telescope.setup({
	defaults = {
		cache_picker = {
			num_pickers = 2,
			limit_entries = 500,
		},
		layout_config = {
			bottom_pane = {
				height = 25,
				preview_cutoff = 120,
				prompt_position = "top",
			},
			horizontal = {
				height = 0.9,
				preview_cutoff = 120,
				prompt_position = "bottom",
				width = 0.9,
			},
			vertical = {
				height = 0.9,
				preview_cutoff = 40,
				prompt_position = "bottom",
				width = 0.9,
			},
		},
		preview = {
			timeout = 500,
		},
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--trim",
		},
		wrap_results = true,
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		live_grep_args = { auto_quoting = true },
	},
})

telescope.load_extension("live_grep_args")

vim.keymap.set(
	"n",
	"<leader>tgs",
	"<CMD>Telescope live_grep_args<CR>",
	{ noremap = true, desc = "[t]elescope live [g]rep [s]earch" }
)
vim.keymap.set(
	"n",
	"<leader>tguc",
	live_grep_args_shortcuts.grep_word_under_cursor,
	{ noremap = true, silent = true, desc = "[t]elescope live [g]rep word [u]nder [c]ursor" }
)
vim.keymap.set(
	"v",
	"<leader>tgvs",
	live_grep_args_shortcuts.grep_visual_selection,
	{ noremap = true, silent = true, desc = "[t]elescope live [g]rep [v]isual [s]election" }
)

vim.keymap.set("n", "<leader>tb", builtin.buffers, { noremap = true, silent = true, desc = "[t]elescope [b]uffers" })
vim.keymap.set("n", "<leader>tfg", function()
	builtin.git_files({ layout_strategy = "vertical" })
end, { noremap = true, silent = true, desc = "[t]elescope find [f]iles added to [g]it" })
vim.keymap.set(
	"n",
	"<leader>gb",
	builtin.git_branches,
	{ noremap = true, silent = true, desc = "[t]elescope [g]it [b]ranches" }
)
vim.keymap.set(
	"n",
	"<leader>gc",
	builtin.git_commits,
	{ noremap = true, silent = true, desc = "[t]elescope [g]it [c]ommits" }
)
vim.keymap.set("n", "<leader>tsh", function()
	builtin.search_history({ layout_strategy = "vertical" })
end, { noremap = true, silent = true, desc = "[t]elescope [s]earch [h]istory" })

vim.keymap.set("n", "<leader>gst", function()
	builtin.git_status({
		use_file_path = true,
		use_git_root = true,
		git_icons = {
			added = "+",
			changed = "~",
			copied = ">",
			deleted = "-",
			renamed = "R",
			unmerged = "‡",
			untracked = "?",
		},
		prompt_title = "Git status",
	})
end, { desc = "[g]it [st]atus", noremap = true, silent = true })

vim.keymap.set(
	{ "n", "v" },
	"gDs",
	builtin.lsp_document_symbols,
	{ noremap = true, desc = "[g]o to [D]ocument [s]ymbols" }
)

vim.keymap.set({ "n", "v" }, "gTd", builtin.lsp_definitions, { noremap = true, desc = "[g]o to [T]ype [d]efinition" })

vim.keymap.set({ "n", "v" }, "gr", builtin.lsp_references, { noremap = true, desc = "[g]o to [r]eferences" })
