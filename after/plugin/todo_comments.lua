local todo = require("todo-comments")

todo.setup({})

vim.keymap.set(
  "n",
  "]t",
  todo.jump_next,
  { desc = "Next todo comment" }
)

vim.keymap.set(
  "n",
  "[t",
  todo.jump_prev,
  { desc = "Previous todo comment" }
)
