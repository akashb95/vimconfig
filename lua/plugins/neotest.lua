return {
	"nvim-neotest/neotest",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-neotest/neotest-python",
		"mrcjkb/rustaceanvim",
	},
	config = function()
		-- Set specific colors for Neotest status icons
		vim.api.nvim_set_hl(0, "NeotestPassed", { fg = "#69db18" }) -- Green
		vim.api.nvim_set_hl(0, "NeotestFailed", { fg = "#e01425" }) -- Red
		vim.api.nvim_set_hl(0, "NeotestRunning", { fg = "#e68115" }) -- Amber
		vim.api.nvim_set_hl(0, "NeotestSkipped", { fg = "#b5b1b1" }) -- Grey
		vim.api.nvim_set_hl(0, "NeotestUnknown", { fg = "#808080" }) -- Grey
		vim.api.nvim_set_hl(0, "NeotestWatching", { fg = "#ff8700" }) -- Orange

		require("neotest").setup({
			adapters = {
				require("rustaceanvim.neotest"),
				require("neotest-python")({
					-- Runner to use. Will use pytest if available by default.
					-- Can also be a function to return dynamic value.
					runner = "pytest",
				}),
			},
			icons = {
				passed = "󰄬",
				failed = "󰅖",
				running = "󰔟",
				skipped = "󰚃",
				unknown = "󰇊",
				watching = "󰈈",
				test = "󰙨",
				child_indent = "│",
				child_prefix = "├",
				collapsed = "󰅂",
				expanded = "󰅀",
				final_child_indent = " ",
				final_child_prefix = "╰",
				non_collapsible = "─",
			},
		})
	end,
	keys = {
		{
			"<leader>trn",
			function()
				require("neotest").run.run()
			end,
			desc = "[t]est [r]un [n]earest",
		},
		{
			"<leader>trf",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "[t]est [r]un in [f]ile",
		},
		{
			"<leader>tst",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "[t]est [s]ummary [t]oggle",
		},
		{
			"<leader>tso",
			function()
				require("neotest").output.open({ enter = true })
			end,
			desc = "[t]est [s]how [o]utput",
		},
		{
			"<leader>top",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "[t]est [o]utput [p]anel",
		},
		{
			"<leader>tqt",
			function()
				require("neotest").run.stop()
			end,
			desc = "[t]est [q]uit [t]est",
		},
		{
			"<leader>trl",
			function()
				require("neotest").run.run_last()
			end,
			desc = "[t]est [r]un [l]ast",
		},
		{
			"<leader>tra",
			function()
				require("neotest").run.run(vim.uv.cwd())
			end,
			desc = "[t]est [r]un [a]ll",
		},
		{
			"<leader>tdbg",
			function()
				require("neotest").run.run({ strategy = "dap" })
			end,
			desc = "[t]est [d]e[b]u[g]",
		},
	},
}
