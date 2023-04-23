local telescope = require("telescope")
local builtin = require('telescope.builtin')
local wk = require("which-key")

telescope.setup({
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
  },
  fzf = {
    fuzzy = true,
    override_generic_sorter = true,
    override_file_sorter = true,
    case_mode = "smart_case",
  },
})

local function search()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end

wk.register({
  ["<leader>t"] = {
    name = "+telescope",
    b = { builtin.buffers, "Buffers" },
    f = {
      "+find",
      f = {
        builtin.find_files,
        "Files",
      },
      g = {
        builtin.git_files,
        "Git files",
      },
      r = {
        function()
          local workspace = "CWD"
          local reporoot_ok, reporoot = pcall(vim.fn.systemlist, "git rev-parse --show-toplevel")
          if reporoot_ok then workspace = reporoot end
          telescope.extensions.frecency.frecency(
            { workspace = workspace }
          )
        end,
        "Recent files"
      },
    },
    s = { search, "Search for string (grep)" },
  },
})

telescope.load_extension("fzf")
telescope.load_extension("frecency")
