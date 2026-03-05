local todo = require("todo-comments")

vim.keymap.set("n", "]t", function()
	todo.jump_next({ keywords = { "FIXME", "TRACE", "TODO" } })
end, { desc = "Next trace comment" })

vim.keymap.set("n", "[t", function()
	todo.jump_prev({ keywords = { "FIXME", "TRACE", "TODO" } })
end, { desc = "Previous trace comment" })
