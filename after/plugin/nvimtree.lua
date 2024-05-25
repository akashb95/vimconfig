local nvim_tree = require("nvim-tree")
local api = require("nvim-tree.api")

nvim_tree.setup({
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
  renderer = {
    add_trailing = true,
    group_empty = true,
  },
  respect_buf_cwd = true,
  sort_by = "case_sensitive",
  sync_root_with_cwd = true,
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
})

vim.keymap.set("n", "<leader>e", function() api.tree.toggle({ find_file = true, focus = true }) end)


local function open_nvim_tree(data)
  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- change to the directory
  -- vim.cmd.cd(data.file)

  -- open the tree
  api.tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
