-- Telescope configuration
require("telescope").setup({
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
  defaults = {
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
  }
})

-- Telescope
local telescope_builtin = require("telescope.builtin")
local telescope_extensions = require("telescope").extensions
local reporoot_ok, reporoot = pcall(vim.fn.systemlist, "git rev-parse --show-toplevel")
if reporoot_ok then
  vim.keymap.set("n", "<leader>fg", function() telescope_extensions.live_grep_args.live_grep_args() end)
  vim.keymap.set("n", "<leader>ff", function() telescope_builtin.find_files({ cwd = reporoot[1] }) end)
else
  vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, {})
  vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, {})
end
vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, {})

require("telescope").load_extension("fzf")
