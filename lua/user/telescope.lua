local telescope = require("telescope")
local lga_actions = require("telescope-live-grep-args.actions")

require("telescope").setup({
  extensions = {
    frecency = {
      default_workspace = "CWD",
      ignore_patterns = {"*.git/*", "*/tmp/*", "*/plz-out/*"},
      workspaces = {
        ["src"] = "$HOME/src",
        ["vault"] = "$HOME/src/vault",
        ["accounts"] = "$HOME/src/vault/kernel/accounts",
        ["nvimconf"] = "$HOME/.config/nvim"
      },
    },
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          -- When Live Grep Args prompt open, write the text and transform accordingly using the following keymaps
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
          ["<C-t>"] = lga_actions.quote_prompt({ postfix = " -t " }),
        }
      }
    }
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
  -- vim.api.nvim_set_keymap(
  --   "n",
  --   "<leader>ff",
  --   string.format("<Cmd>lua require('telescope').extensions.frecency.frecency({ workspace = '${reporoot}' })<CR>", {reporoot=reporoot}),
  --   {noremap = true, silent = true}
  -- )
  vim.keymap.set("n", "<leader>ff", function() telescope_builtin.find_files({ cwd = reporoot[1] }) end)
  vim.keymap.set(
    "n",
    "<leader>fg",
    function()
      telescope_extensions.live_grep_args.live_grep_args()
    end
  )
else
  vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, {})
  -- vim.api.nvim_set_keymap(
  --   "n",
  --   "<leader>ff",
  --   "<Cmd>lua require('telescope').extensions.frecency.frecency({ workspace = 'CWD' })<CR>",
  --   {noremap = true, silent = true}
  -- )
  vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, {})
end
vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, {})

telescope.load_extension("fzf")
-- telescope.load_extension("frecency")
