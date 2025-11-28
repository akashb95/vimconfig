local disable_format_on_save = false

vim.keymap.set("n", "<leader>ft", function()
	disable_format_on_save = not disable_format_on_save
	if disable_format_on_save then
		vim.notify("Disabled format on save")
	else
		vim.notify("Enabled format on save")
	end
end, { desc = "[F]ormat on save [T]oggle" })

local function capture_shell(command)
	print("command to execute: " .. command)
	local cmd_out = vim.fn.execute(":!" .. command, "")
	local lines = {}
	for line in cmd_out:gmatch("[^\n]+") do
		table.insert(lines, line)
	end
	print("lines: ")
	print(table.concat(lines, "\n"))
	table.remove(lines, 1)

	return table.concat(lines, "\n")
end

local function parse_gci_args()
	local args = { "write", "--skip-generated", "$FILENAME" }

	local config_file = vim.fs.find(".golangci.yml", { upward = true })[1]
	if (not config_file) or vim.fn.executable("yq") ~= 1 then
		return args
	end

	local out = capture_shell("echo $(yq '.linters-settings.gci' -o json < " .. config_file .. ")")
	local gci_config = vim.json.decode(out)

	for _, section in ipairs(gci_config.sections) do
		table.insert(args, "-s")
		table.insert(args, section)
	end

	if gci_config["custom-order"] then
		table.insert(args, "--custom-order")
	end

	return args
end

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
      command = "cargo",
      args = {
        "fmt",
        "--", -- Separator for rustfmt arguments
        "--config",
        "comment_width=120,condense_wildcard_suffixes=false,format_code_in_doc_comments=true,format_macro_bodies=true,hex_literal_case=Upper,imports_granularity=One,normalize_doc_attributes=true,wrap_comments=true",
      },
      stdin = true,
      -- Set the working directory to the project root containing Cargo.toml
      -- This ensures 'cargo fmt' runs correctly.
      cwd = require("conform.util").root_file({ "Cargo.toml" }),
    }
	},

	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		go = go_formatters,
		javascript = { "prettier" },
		json = { "prettier" },
		html = { "prettier" },
    rust = { "cargofmt" }
	},

	format_on_save = function()
		if disable_format_on_save then
			return
		end
		return { timeout_ms = 10000 }
	end,
})
