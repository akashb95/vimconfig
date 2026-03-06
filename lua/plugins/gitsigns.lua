return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local gitsigns = require("gitsigns")

		gitsigns.setup({
			update_debounce = 200,
			current_line_blame_opts = {
				virt_text = false,
				virt_text_pos = "right_align",
				ignore_whitespace = true,
			},
			on_attach = function(bufnr)
				local gs = gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]h", function()
					if vim.wo.diff then
						return "]h"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Jump to next hunk" })

				map("n", "[h", function()
					if vim.wo.diff then
						return "[h"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Jump to previous hunk" })

				map("n", "<leader>gsb", gs.stage_buffer, { desc = "[g]it [s]tage [b]uffer" })
				map({ "n", "v" }, "<leader>gsh", ":Gitsigns stage_hunk<CR>", { desc = "[g]it [s]tage [h]unk" })

				map("n", "<leader>gR", gs.reset_buffer, { desc = "[g]it [R]eset buffer" })
				map({ "n", "v" }, "<leader>grh", ":Gitsigns reset_hunk<CR>", { desc = "[g]it [r]eset [h]unk" })

				map("n", "<leader>gd", gs.diffthis, { desc = "[g]it [d]iff against index" })
				map("n", "<leader>gD", function()
					gs.diffthis("~")
				end, { desc = "[g]it [D]iff against HEAD" })
			end,
		})
	end,
}

