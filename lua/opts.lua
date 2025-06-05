vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = os.getenv("NERD_FONT") ~= vim.o.swapfile == false

vim.opt.clipboard = { "unnamed", "unnamedplus" }

vim.o.spell = false

vim.o.number = true
vim.o.relativenumber = true

-- default items in popup menu (e.g. for autocompletion suggestions)
vim.o.pumheight = 7

vim.o.linebreak = true

vim.o.scrolloff = 5

vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true

vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- vim.o.hidden = true -- allow moving to other files without saving

vim.o.cursorline = false
vim.o.lazyredraw = true

vim.o.mouse = "a"

vim.o.showmode = false
vim.o.signcolumn = "yes:2"

-- split screen settings
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.termguicolors = true
vim.o.updatetime = 80

vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Folding
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd("set whichwrap+=<,>,[,],h,l")

require("file_types").setup({
	lua = {
		tab_size = 2,
		text_width = 120,
	},
	javascript = {
		tab_size = 2,
	},
	typescript = {
		tab_size = 2,
	},
	json = {
		tab_size = 2,
	},
	jsonc = {
		tab_size = 2,
	},
	python = {
		text_width = 120,
	},
	go = {
		text_width = 120,
		indent_with_tabs = false,
	},
	proto = {
		text_width = 120,
	},
	query = {
		tab_size = 2,
	},
	zsh = {
		tab_size = 2,
	},
	markdown = {
		text_width = 120,
		auto_wrap = true,
	},
	html = {
		tab_size = 2,
	},
	sql = {
		tab_size = 2,
		text_width = 120,
	},
	please = {
		text_width = 120,
	},
})

vim.diagnostic.config({
	severity_sort = true,
	update_in_insert = true,
	virtual_text = true,
	float = {
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})

vim.filetype.add({
	filename = {
		["new-commit"] = "arcdiff",
	},
})
