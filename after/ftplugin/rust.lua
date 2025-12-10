if vim.fn.exists(":RustLsp") == 0 then
	-- Sometimes, the RustLsp crashes or fails to boot up.
	-- In that case, fall back to the default functionality provided by neovim.
	return
end

local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set({ "n", "v" }, "<leader>ca", function()
	vim.cmd.RustLsp("codeAction") -- supports rust-analyzer"s grouping
	-- or vim.lsp.buf.codeAction() if you don"t want grouping.
end, { silent = true, buffer = bufnr, desc = "Code action" })

vim.keymap.set(
	"n",
	"K", -- Override Neovim"s built-in hover keymap with rustaceanvim"s hover actions
	function()
		vim.cmd.RustLsp({ "hover", "actions" })
	end,
	{ silent = true, buffer = bufnr, desc = "Rustacean Hover" }
)

vim.keymap.set("n", "df", function()
	vim.cmd.RustLsp({ "renderDiagnostic", "current" })
end, { silent = true, buffer = bufnr, desc = "[d]iagnostic float" })
vim.keymap.set("n", "]d", function()
	vim.cmd.RustLsp({ "renderDiagnostic", "cycle" })
end, { silent = true, buffer = bufnr, desc = "next [d]iagnostic" })
vim.keymap.set("n", "[d", function()
	vim.cmd.RustLsp({ "renderDiagnostic", "cycle_prev" })
end, { silent = true, buffer = bufnr, desc = "previous [d]iagnostic" })
vim.keymap.set("n", "grd", function()
	vim.cmd.RustLsp("relatedDiagnostics")
end, { silent = true, buffer = bufnr, desc = "[g]o to [r]elated [d]iagnostics" })

vim.keymap.set({ "n", "v" }, "gxm", function()
	vim.cmd.RustLsp("expandMacro")
end, { silent = true, buffer = bufnr, desc = "[g]o e[x]pand [m]acros" })

vim.keymap.set({ "n", "v" }, "gK", function()
	vim.cmd.RustLsp("openDocs")
end, { silent = true, buffer = bufnr, desc = "[G]o to Rust do[K]s" })

vim.keymap.set("n", "J", function()
	vim.cmd.RustLsp("joinLines")
end, { silent = true, buffer = bufnr, desc = "[J]oin lines" })

vim.keymap.set("n", "<leader>ftr", function()
	vim.cmd.RustLsp({ "flyCheck", "run" })
end, { silent = true, buffer = bufnr, desc = "[f]orma[t]ter [r]un (cargo check)" })
vim.keymap.set("n", "<leader>ftc", function()
	vim.cmd.RustLsp({ "flyCheck", "clear" })
end, { silent = true, buffer = bufnr, desc = "[f]orma[t]ter [c]lear" })
