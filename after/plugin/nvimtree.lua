local nvim_tree = require("nvim-tree")
local api = require("nvim-tree.api")

nvim_tree.setup({
  renderer = {
    group_empty = true,
  },
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
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
