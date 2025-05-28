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
    autocmd BufWritePost packer.lua source <afile> | PackerSync
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

return packer.startup(
  function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
      'nvim-telescope/telescope.nvim', tag = '0.1.8',
      requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use {
      "nvim-telescope/telescope-frecency.nvim",
      requires = {
        { "kkharji/sqlite.lua" } -- Ensure SQLite also installed on OS.
      }
    }
    use {
      "nvim-telescope/telescope-fzf-native.nvim",
      run =
      "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    }
    use { "junegunn/fzf", run = ":call fzf#install()" }
    use { "junegunn/fzf.vim" }
    use { "fspv/sourcegraph.nvim" }

    -- Theme
    use {
      "briones-gabriel/darcula-solid.nvim",
      requires = "rktjmp/lush.nvim",
      config = function()
        vim.cmd("colorscheme darcula-solid")
        vim.cmd("set termguicolors")
      end,
    }

    use { "nvim-tree/nvim-tree.lua", tag = "nightly" }
    use { "nvim-tree/nvim-web-devicons" }

    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      requires = {
        { "nvim-treesitter/nvim-treesitter-context" },
        { "nvim-treesitter/nvim-treesitter-textobjects" },
      },
    }
    use {
      "nvim-treesitter/nvim-treesitter-textobjects",
    }
    use {
      "nvim-treesitter/nvim-treesitter-context",
      config = function() require("treesitter-context").setup() end,
    }

    use { "tpope/vim-fugitive" }
    use {
      "lewis6991/gitsigns.nvim",
      requires = { "echasnovski/mini.icons" },
    }
    use { "f-person/git-blame.nvim" }

    -- Editor essentials.
    use { 'numToStr/Comment.nvim' }
    use { "kylechui/nvim-surround", tag = "main" }
    use { "David-Kunz/markid" }
    use { "windwp/nvim-autopairs" }
    use { "ggandor/leap.nvim" }
    use {
      "nvim-lualine/lualine.nvim",
      requires = { "kyazdani42/nvim-web-devicons", opt = true }
    }
    use {
      "kevinhwang91/nvim-ufo",
      requires = { "kevinhwang91/promise-async" },
    }                               -- folding
    use { "kevinhwang91/nvim-hlslens" }
    use { "karb94/neoscroll.nvim" } -- Smooth-scrolling
    use { "petertriho/nvim-scrollbar" }
    use { "ojroques/nvim-osc52" }
    use { "folke/todo-comments.nvim" }

    use { 'saadparwaiz1/cmp_luasnip' }

    use {
      "williamboman/mason.nvim",
      run = function()
        pcall(vim.cmd, 'MasonUpdate')
      end,
      requires = {
        { "williamboman/mason-lspconfig.nvim" }, -- Optional
        { "neovim/nvim-lspconfig" },             -- Required
        -- Autocompletion
        { "hrsh7th/nvim-cmp" },                  -- Required
        { "hrsh7th/cmp-nvim-lsp" },              -- Required
        { "L3MON4D3/LuaSnip" },                  -- Required
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-cmdline" },
        { "hrsh7th/cmp-nvim-lua" },
        { "lukas-reineke/cmp-rg" },
      },
    }

    use {
      "VonHeikemen/lsp-zero.nvim",
      branch = 'v2.x',
      requires = {
        -- LSP Support

        {
          "williamboman/mason.nvim",
          run = function()
            pcall(vim.cmd, 'MasonUpdate')
          end,
        },                                       -- Optional
        { "williamboman/mason-lspconfig.nvim" }, -- Optional
      }
    }

    use {
      "Wansmer/treesj",
    }

    -- use { "stevearc/conform.nvim" }

    use {
      "folke/which-key.nvim",
      config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 250
        require("which-key").setup({
          win = {
            border = "none",      -- none, single, double, shadow
            title_pos = "center", -- bottom, top
            height = { min = 2, max = 15 },
            wo = { winblend = 10 },
            zindex = 1000, -- positive value to position WhichKey above other floating windows.
          },
        })
      end,
    }

    -- Workflow particulars.
    use { "iamcco/markdown-preview.nvim", cmd = "MarkdownPreview" }
    use { "rcarriga/nvim-dap-ui",
      requires = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
        "theHamsta/nvim-dap-virtual-text",
      }
    }
    use {
      "marcuscaisey/please.nvim",
      requires = {
        "mfussenegger/nvim-dap",
        "stevearc/dressing.nvim",
        "rcarriga/nvim-dap-ui",
      },
    }
    use { "yorickpeterse/nvim-pqf" }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
      require("packer").sync()
    end
  end
)
