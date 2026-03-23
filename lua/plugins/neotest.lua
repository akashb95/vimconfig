return {
	"nvim-neotest/neotest",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-python",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-python")({
					-- Runner to use. Will use pytest if available by default.
					-- Can also be a function to return dynamic value.
					runner = "pytest",
				}),
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
