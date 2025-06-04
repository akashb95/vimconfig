local telescope = require("telescope")
local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
local lga_actions = require("telescope-live-grep-args.actions")
local builtin = require('telescope.builtin')

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
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    live_grep_args = { auto_quoting = true },
  },
})

telescope.load_extension("live_grep_args")

vim.keymap.set(
  "n",
  "<leader>tgs",
  lga_actions.quote_prompt,
  { noremap=true, desc = "[t]elescope live [g]rep [s]earch" }
)
vim.keymap.set(
  "n",
  "<leader>tguc",
  live_grep_args_shortcuts.grep_word_under_cursor,
  { noremap=true, silent = true, desc = "[t]elescope live [g]rep word [u]nder [cursor]" }
)
vim.keymap.set(
  "v",
  "<leader>tgvs",
  live_grep_args_shortcuts.grep_visual_selection,
  { noremap=true, silent = true, desc = "[t]elescope live [g]rep [v]isual [s]election" }
)

vim.keymap.set('n', '<leader>tb', builtin.buffers, { noremap = true, silent = true, desc = "[t]elescope [b]uffers" })
vim.keymap.set(
  'n',
  '<leader>tfg',
  function() builtin.git_files({ layout_strategy = "vertical" }) end,
  { noremap = true, silent = true, desc = '[t]elescope find [f]iles added to [g]it' }
)
vim.keymap.set(
  'n',
  '<leader>tsh',
  function() builtin.git_files({ layout_strategy = "vertical" }) end,
  { noremap = true, silent = true, desc = '[t]elescope [s]earch [h]istory' }
)
