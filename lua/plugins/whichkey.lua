return {
  "folke/which-key.nvim",
  lazy = false,
  dependencies = {
    {
      'nvim-tree/nvim-web-devicons',
    },
  },
  opts = {
    win = {
      border = "none",
      title_pos = "center",
      height = { min = 2, max = 15 },
      wo = { winblend = 10 },
      zindex = 1000,
    }
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
