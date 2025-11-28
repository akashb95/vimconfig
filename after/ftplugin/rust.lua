local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set({ "n", "v" }, "<leader>ca", function()
	vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
	-- or vim.lsp.buf.codeAction() if you don't want grouping.
end, { silent = true, buffer = bufnr, desc = "Code action" })

vim.keymap.set(
	"n",
	"K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
	function()
		vim.cmd.RustLsp({ "hover", "actions" })
	end,
	{ silent = true, buffer = bufnr, desc = "Rustacean Hover" }
)

vim.keymap.set(
  {"n", "v"},
  "gK",
  function ()
    vim.cmd.RustLsp("openDocs")
  end,
  { silent = true, buffer = bufnr, desc = "[G]o to Rust do[K]s" }
)

vim.keymap.set(
  "n",
  "J",
  function ()
    vim.cmd.RustLsp('joinLines')
  end,
  { silent = true, buffer = bufnr, desc = "[J]oin lines" }
)

vim.keymap.set(
  "n",
  "<leader>ftr",
  function ()
    vim.cmd.RustLsp {"flyCheck", "run"}
  end,
  { silent = true, buffer=bufnr, desc = "[f]orma[t]ter [r]un (cargo check)" }
)
vim.keymap.set(
  "n",
  "<leader>ftc",
  function ()
    vim.cmd.RustLsp {"flyCheck", "clear"}
  end,
  { silent = true, buffer=bufnr, desc = "[f]orma[t]ter [c]lear" }
)
