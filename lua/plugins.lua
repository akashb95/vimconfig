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

  -- Very common deps
  use { "nvim-lua/plenary.nvim" }
  use { "nvim-tree/nvim-web-devicons" }
  use { "folke/neodev.nvim" }

  -- Surround
  use {
    "kylechui/nvim-surround",
    config = function() require("nvim-surround").setup() end
  }

  -- highlight comments beginning with TODO.
  use {
    "folke/todo-comments.nvim",
    config = function() require("todo-comments").setup({}) end,
  }

  -- buffer navigation
  use {
    "ggandor/leap.nvim",
    config = function() require("leap").add_default_mappings() end,
  }

  -- fs navigation
  use {
    'nvim-tree/nvim-tree.lua',
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

  use { "iamcco/markdown-preview.nvim", cmd = "MarkdownPreview" }

  -- Git signs
  use { "lewis6991/gitsigns.nvim" }

  -- statusline - lualine
  use {
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true }
  }

  -- Treesitter
  use { "nvim-treesitter/nvim-treesitter" }
  use { "nvim-treesitter/nvim-treesitter-textobjects" }
  use { "p00f/nvim-ts-rainbow" }

  -- Autocompletion
  use { "hrsh7th/nvim-cmp" }
  use { "hrsh7th/cmp-nvim-lsp" }
  use { "hrsh7th/cmp-buffer" } -- buffer completions
  use { "hrsh7th/cmp-path" } -- path completions
  use { "hrsh7th/cmp-cmdline" }
  use { "lukas-reineke/cmp-rg" }

  use { "rafamadriz/friendly-snippets" }
  use { "L3MON4D3/LuaSnip", tag = "v1.1.0" }
  use { "saadparwaiz1/cmp_luasnip" }

  -- LSPs and LSP installer
  use {
    -- Ordering is important.
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig"
  }
  use {
    "ray-x/lsp_signature.nvim",
    config = function() require("lsp_signature").setup({
      bind = true,
      hint_enable = false,
    }) end,
  }

  -- Telescope
  use { "nvim-telescope/telescope.nvim", tag = "0.1.0" }
  use { "vijaymarupudi/nvim-fzf" }

  use { "windwp/nvim-autopairs" }

  -- Darcula theme
  use { "doums/darcula" }

  -- Smooth scrolling
  use { "karb94/neoscroll.nvim" }

  -- Commenting
  use {
    "numToStr/Comment.nvim",
    config = function() require("Comment").setup() end,
  }

  -- Please integration.
  use {
    "marcuscaisey/please.nvim",
    requires = { "mfussenegger/nvim-dap" }
  }

  -- Formatter
  -- use { "sbdchd/neoformat" }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
