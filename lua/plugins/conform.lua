return {
	"stevearc/conform.nvim",
	opts = function()
		local go_formatters = { "gofmt", "goimports" }
		if vim.fn.executable("gci") == 1 then
			go_formatters = { "goimports", "gofmt", "gci" }
		end

		return {
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
				python = { "ruff_fix", "ruff_format" },
				go = go_formatters,
				javascript = { "prettier" },
				json = { "prettier" },
				html = { "prettier" },
				markdown = { "prettier" },
				yaml = { "yamlfmt" },
				rust = { "cargofmt" },
				sql = { "sleek" },
			},
		}
	end,
	config = function(_, opts)
		local disable_format_on_save = false

		vim.keymap.set("n", "<leader>ft", function()
			disable_format_on_save = not disable_format_on_save
			if disable_format_on_save then
				vim.notify("Disabled format on save")
			else
				vim.notify("Enabled format on save")
			end
		end, { desc = "[F]ormat on save [T]oggle" })
		opts.format_on_save = function()
			if disable_format_on_save then
				return
			end
			return { timeout_ms = 10000 }
		end
		require("conform").setup(opts)

		-- Run golangci-lint run --fix after save on the actual file so it uses the
		-- same .golangci.yml config as CI. Must run post-write (not pre-write) because
		-- golangci-lint needs the file on disk, not a stdin buffer.
		-- Runs via `go tool` (not a PATH binary) so the repo's pinned go.mod tool
		-- version is used, not whatever is installed system-wide.
		vim.api.nvim_create_autocmd("BufWritePost", {
			group = vim.api.nvim_create_augroup("GolangCILint", { clear = true }),
			pattern = "*.go",
			callback = function(ev)
				if disable_format_on_save then
					return
				end
				if vim.fn.executable("go") == 0 then
					return
				end
				local filepath = vim.api.nvim_buf_get_name(ev.buf)
				local dirname = vim.fn.fnamemodify(filepath, ":h")
				local root = vim.fs.root(filepath, { "go.mod" })
				if not root then
					return
				end
				-- Compute path of the current package relative to the module root.
				-- golangci-lint picks up .golangci.yml automatically when cwd is the root.
				local rel = dirname:sub(#root + 2)
				local pkg = rel ~= "" and ("./" .. rel) or "."
				vim.system({ "go", "tool", "golangci-lint", "run", "--fix", pkg }, { cwd = root }, function()
					vim.schedule(function()
						if vim.api.nvim_buf_is_valid(ev.buf) then
							vim.cmd("checktime " .. vim.fn.fnameescape(filepath))
						end
					end)
				end)
			end,
		})
	end,
}
