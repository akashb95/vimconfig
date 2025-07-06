local gitsigns = require("gitsigns")

local function on_attach(bufnr)
	-- Navigation shortcuts
	vim.keymap.set("n", "]c", function()
		if vim.wo.diff then
			return "]c"
		end
		vim.schedule(function()
			gitsigns.next_hunk()
		end)
		return "<Ignore>"
	end, { expr = true, buffer = bufnr, desc = "jump to next hunk" })

	vim.keymap.set("n", "[c", function()
		if vim.wo.diff then
			return "[c"
		end
		vim.schedule(function()
			gitsigns.prev_hunk()
		end)
		return "<Ignore>"
	end, { expr = true, buffer = bufnr, desc = "jump to prev hunk" })

	vim.keymap.set(
		"n",
		"<leader>gd",
		gitsigns.diffthis,
		{ noremap = true, buffer = bufnr, silent = true, desc = "[g]it [d]iff" }
	)

	vim.keymap.set("n", "<leader>gD", function()
		gitsigns.diffthis("~")
	end, { noremap = true, buffer = bufnr, silent = true, desc = "[g]it [D]iff against head" })

	vim.keymap.set(
		"n",
		"<leader>grh",
		gitsigns.reset_hunk,
		{ noremap = true, buffer = bufnr, silent = true, desc = "[g]it [r]eset [h]unk" }
	)

	vim.keymap.set(
		"n",
		"<leader>gR",
		gitsigns.reset_buffer,
		{ noremap = true, buffer = bufnr, silent = true, desc = "[g]it [R]eset buffer" }
	)

	vim.keymap.set(
		"n",
		"<leader>gsb",
		gitsigns.stage_buffer,
		{ noremap = true, buffer = bufnr, silent = true, desc = "[g]it [s]tage [b]uffer" }
	)

	vim.keymap.set(
		"n",
		"<leader>gsh",
		gitsigns.stage_hunk,
		{ noremap = true, buffer = bufnr, silent = true, desc = "[g]it [s]tage [h]unk" }
	)
end

gitsigns.setup({
	update_debounce = 1000,
	current_line_blame_opts = {
		virt_text = false,
		virt_text_pos = "right_align",
		ignore_whitespace = true,
	},
	on_attach = on_attach,
})
