local ok, please = pcall(require, "please")
if not ok then return
else
  vim.keymap.set("n", "<leader>pb", please.build, { silent = true } )
  vim.keymap.set("n", "<leader>py", please.yank, { silent = true } )
end
