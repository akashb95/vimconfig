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
  use { "kkharji/sqlite.lua" }  -- Ensure SQLite also installed on OS.

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
  use {
    "simrat39/symbols-outline.nvim",
    config = function () require("symbols-outline").setup() end,
  }

  -- fs navigation
  use {
    'nvim-tree/nvim-tree.lua',
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

  use { "iamcco/markdown-preview.nvim", cmd = "MarkdownPreview" }

  -- Git signs
  use { "lewis6991/gitsigns.nvim" }
  use { "f-person/git-blame.nvim" }

  -- statusline - lualine
  use {
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true }
  }

  -- Treesitter
  use { "nvim-treesitter/nvim-treesitter" }
  use { "nvim-treesitter/nvim-treesitter-textobjects" }
  use {
    "nvim-treesitter/nvim-treesitter-context",
    config = function () require("treesitter-context").setup({}) end,
  }
  use { "nvim-treesitter/playground" }
  use { "David-Kunz/markid" }
  use { "mrjones2014/nvim-ts-rainbow" }

  -- Folding
  use {
    "kevinhwang91/nvim-ufo",
    requires = {"kevinhwang91/promise-async"},
  }

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
  use {
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  }
  use {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("telescope").load_extension("live_grep_args")
    end,
    requires = {
      { "nvim-telescope/telescope-live-grep-args.nvim" },
    },
    tag = "0.1.0",
  }
  use { "nvim-telescope/telescope-frecency.nvim" }

  use { "windwp/nvim-autopairs" }

  -- Darcula theme
  -- use { "doums/darcula" }
  use {
    "briones-gabriel/darcula-solid.nvim",
    requires = "rktjmp/lush.nvim",
  }

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

  -- Make quickfix entries prettier (e.g. when using `gr`).
  use {
    "https://gitlab.com/yorickpeterse/nvim-pqf",
    config = function() require("pqf").setup() end
  }

  -- Copy text and put on system clipboard.
  use {
    "ojroques/nvim-osc52",
    config = function()
      local osc52 = require("osc52")
      osc52.setup({trim = true}) -- Trim text before copy

      local function copy()
        if vim.v.event.operator == 'y' and vim.v.event.regname == 'c' then
          osc52.copy_register("c")
        end
      end
      vim.api.nvim_create_autocmd("TextYankPost", {callback = copy})
    end
  }

  use {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
      }
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
