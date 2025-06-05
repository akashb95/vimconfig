local todo = require("todo-comments")

vim.keymap.set("n", "]T", function()
	todo.jump_next({ keywords = { "TRACE", "INVESTIGATION", "TRACK" } })
end, { desc = "Next trace comment" })

vim.keymap.set("n", "[T", function()
	todo.jump_prev({ keywords = { "TRACE", "INVESTIGATION", "TRACK" } })
end, { desc = "Previous trace comment" })
