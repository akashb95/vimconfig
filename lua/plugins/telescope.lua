return {
  'nvim-telescope/telescope.nvim', -- Fuzzy Finder (files, LSP, etc)
  branch = 'master',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',
    },
    {
      'nvim-tree/nvim-web-devicons', -- Useful for getting pretty icons, but requires a Nerd Font.
      enabled = vim.g.have_nerd_font,
    },
  },
}
