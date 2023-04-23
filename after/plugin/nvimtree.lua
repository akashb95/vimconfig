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

local function copy_file_to(node)
  local file_src = node['absolute_path']
  -- The args of input are {prompt}, {default}, {completion}
  -- Read in the new file path using the existing file's path as the baseline.
  local file_out = vim.fn.input("COPY TO: ", file_src, "file")

  -- Create any parent dirs as required
  local dir = vim.fn.fnamemodify(file_out, ":h")
  vim.fn.system { 'mkdir', '-p', dir }

  -- Copy the file
  vim.fn.system { 'cp', '-R', file_src, file_out }
end

vim.keymap.set('n', 'c', copy_file_to)

local git_add = function()
  local node = api.tree.get_node_under_cursor()
  local git_status = node.git_status.file

  -- If the current node is a directory get children status
  if git_status == nil then
    git_status = (node.git_status.dir.direct ~= nil and node.git_status.dir.direct[1])
        or (node.git_status.dir.indirect ~= nil and node.git_status.dir.indirect[1])
  end

  -- If the file is untracked, unstaged or partially staged, we stage it
  if git_status == "??" or git_status == "MM" or git_status == "AM" or git_status == " M" then
    vim.cmd("silent !git add " .. node.absolute_path)

    -- If the file is staged, we unstage
  elseif git_status == "M " or git_status == "A " then
    vim.cmd("silent !git restore --staged " .. node.absolute_path)
  end

  api.tree.reload()
end

vim.keymap.set('n', 'ga', git_add)
