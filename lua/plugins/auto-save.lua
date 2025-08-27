local excluded_filetypes = {
	-- this one is especially useful if you use neovim as a commit message editor
	"gitcommit",
	-- most of these are usually set to non-modifiable, which prevents autosaving
	-- by default, but it doesn't hurt to be extra safe.
	"NvimTree",
	"Outline",
	"TelescopePrompt",
	"alpha",
	"dashboard",
	"lazygit",
	"neo-tree",
	"oil",
	"prompt",
	"toggleterm",
}

local excluded_filenames = {}

local function save_condition(buf)
	if
		vim.tbl_contains(excluded_filetypes, vim.fn.getbufvar(buf, "&filetype"))
		or vim.tbl_contains(excluded_filenames, vim.fn.expand("%:t"))
	then
		return false
	end
	return true
end

return {
	"okuuva/auto-save.nvim",
	version = "*", -- alternatively use '*' to use the latest tagged release
	cmd = "ASToggle", -- optional for lazy loading on command
	event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
	opts = {
		condition = save_condition,
		debounce_delay = 5000,
	},
}
