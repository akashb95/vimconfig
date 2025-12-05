local disable_format_on_save = false

vim.keymap.set("n", "<leader>ft", function()
	disable_format_on_save = not disable_format_on_save
	if disable_format_on_save then
		vim.notify("Disabled format on save")
	else
		vim.notify("Enabled format on save")
	end
end, { desc = "[F]ormat on save [T]oggle" })

local go_formatters = { "gofmt", "goimports" }
if vim.fn.executable("gci") == 1 then
	go_formatters = { "goimports", "gofmt", "gci" }
end

require("conform").setup({
	formatters = {
		-- gci = {
		-- 	args = parse_gci_args(),
		-- },
		cargofmt = {
			command = "rustfmt",
			args = {
				"--emit",
				"stdout",
				"--config",
				"comment_width=120,condense_wildcard_suffixes=false,format_code_in_doc_comments=true,format_macro_bodies=true,hex_literal_case=Upper,imports_granularity=One,normalize_doc_attributes=true,wrap_comments=true",
			},
			stdin = true,
			-- Set the working directory to the project root containing Cargo.toml
			-- This ensures 'cargo fmt' runs correctly.
			cwd = require("conform.util").root_file({ "Cargo.toml" }),
		},
	},

	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		go = go_formatters,
		javascript = { "prettier" },
		json = { "prettier" },
		html = { "prettier" },
		rust = { "cargofmt" },
	},

	format_on_save = function()
		if disable_format_on_save then
			return
		end
		return { timeout_ms = 10000 }
	end,
})
