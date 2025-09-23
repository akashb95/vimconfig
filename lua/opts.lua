vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

vim.opt.syntax = "off"

-- Disable parens matching because it causes too much lag.
vim.g.loaded_matchparen = 1

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = os.getenv("NERD_FONT") ~= vim.o.swapfile == false

vim.opt.clipboard = "unnamedplus"

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

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd("set whichwrap+=<,>,[,],h,l")

vim.filetype.add({
	filename = {
		["new-commit"] = "arcdiff",
	},
})

require("file_types").setup({
	go = {
		text_width = 120,
		indent_with_tabs = false,
	},
	html = {
		tab_size = 2,
	},
	javascript = {
		tab_size = 2,
	},
	json = {
		tab_size = 2,
		indent_with_tabs = false,
	},
	jsonc = {
		tab_size = 2,
	},
	lua = {
		tab_size = 2,
		text_width = 120,
	},
	markdown = {
		text_width = 120,
		auto_wrap = true,
	},
	python = {
		text_width = 100,
	},
	please = {
		text_width = 120,
	},
	proto = {
		text_width = 120,
	},
	query = {
		tab_size = 2,
	},
	rust = {
		indent_with_tabs = false,
		text_width = 120,
	},
	sql = {
		tab_size = 2,
		text_width = 120,
	},
	typescript = {
		tab_size = 2,
	},
	yaml = {
		tab_size = 2,
		indent_with_tabs = false,
	},
	zsh = {
		tab_size = 2,
	},
})

vim.diagnostic.config({
	severity_sort = true,
	update_in_insert = false,
	virtual_text = true,
	float = {
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})
