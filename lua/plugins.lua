local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- must be first
  use { "nvim-lua/plenary.nvim" }
  use { "nvim-tree/nvim-web-devicons" }
  use { "folke/neodev.nvim" }

  -- navigation
  use {
    'nvim-tree/nvim-tree.lua',
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

  use { "windwp/nvim-autopairs" }

  use {"iamcco/markdown-preview.nvim", cmd = "MarkdownPreview"}


  -- statusline - lualine
  use {
  'nvim-lualine/lualine.nvim',
  requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- Autocompletion
  use { "hrsh7th/cmp-nvim-lsp" }
  use { "hrsh7th/cmp-buffer" } -- buffer completions
  use { "hrsh7th/cmp-path" } -- path completions
  use { "hrsh7th/cmp-cmdline" }
  use { "hrsh7th/nvim-cmp" }

  -- TODO: find out what these do
  use { 'hrsh7th/cmp-vsnip' }
  use { 'hrsh7th/vim-vsnip' }

  -- LSPs and LSP installer
  use {
    -- Ordering is important.
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig"
  }
  -- use { "hrsh7th/cmp-nvim-lua" }

  -- Telescope
  use { "nvim-telescope/telescope.nvim", tag = "0.1.0" }
  use { "vijaymarupudi/nvim-fzf" }

  -- Golang specific
  use 'ray-x/go.nvim'
  use 'ray-x/guihua.lua' -- floating window support

  -- Darcula theme
  use {
    "briones-gabriel/darcula-solid.nvim",
    requires = "rktjmp/lush.nvim",
  }

  -- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
