local telescope = require("telescope")
local builtin = require('telescope.builtin')
local wk = require("which-key")

telescope.setup({
  defaults = {
    cache_picker = {
      num_pickers = 2,
      limit_entries = 500,
    },
    layout_config = {
      bottom_pane = {
        height = 25,
        preview_cutoff = 120,
        prompt_position = "top"
      },
      horizontal = {
        height = 0.9,
        preview_cutoff = 120,
        prompt_position = "bottom",
        width = 0.9
      },
      vertical = {
        height = 0.9,
        preview_cutoff = 40,
        prompt_position = "bottom",
        width = 0.9
      }
    },
    preview = {
      timeout = 500,
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--trim",
    },
    wrap_results = true,
  },
  extensions = {
    frecency = {
      default_workspace = "CWD",
      ignore_patterns = { "*.git/*", "*/tmp/*", "*/plz-out/*" },
      workspaces = {
        ["src"] = "$HOME/core3/src",
        ["vault"] = "$HOME/core3/src/vault",
        ["accounts"] = "$HOME/core3/src/vault/kernel/accounts",
        ["accounts2"] = "$HOME/core3/src/vault/core/accounts",
        ["nvimconf"] = "$HOME/.config/nvim"
      },
    },
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

vim.keymap.set(
  'v',
  '<leader>tfs',
  function()
    -- Yank the current visual selection into to register
    vim.cmd('normal! "py')

    -- Get the content of register and escape spaces
    local visual_selection = vim.fn.escape(vim.fn.getreg('p'), ' ')

    -- Call Telescope live_grep with the escaped visual selection
    vim.cmd('Telescope live_grep default_text=' .. visual_selection)
  end,
  { noremap = true, silent = true }
)

wk.add({
  { "<leader>t",   group = "telescope" },
  { "<leader>tb",  builtin.buffers,                                                    desc = "Buffers" },
  { "<leader>tf",  group = "find",                                                     desc = "find" },
  { "<leader>tfg", function() builtin.git_files({ layout_strategy = "vertical" }) end, desc = "Git files" },
  { "<leader>tfs", desc = "Visual Selection" },
  {
    "<leader>tfr",
    function()
      local workspace = "CWD"
      local reporoot_ok, reporoot = pcall(vim.fn.systemlist, "git rev-parse --show-toplevel")
      if reporoot_ok then workspace = reporoot end
      telescope.extensions.frecency.frecency(
        { workspace = workspace }
      )
    end,
    desc = "Recent files"
  },
  {
    "<leader>th",
    function() builtin.search_history({ layout_strategy = "vertical" }) end,
    desc = "Search history"
  },
  {
    "<leader>ts",
    function() builtin.grep_string({ search = vim.fn.input("Grep > ") }) end,
    desc = "Search for string (grep)"
  },
})

telescope.load_extension("fzf")
telescope.load_extension("frecency")
