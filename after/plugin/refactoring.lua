local refactoring = require("refactoring")

refactoring.setup()

vim.keymap.set({ "n", "x" }, "<leader>ref", function()
	return refactoring.refactor("Extract Function")
end, { desc = "[r]efactor: [e]xtract [f]unction", expr = true })

vim.keymap.set({ "n", "x" }, "<leader>reF", function()
	return refactoring.refactor("Extract Function To File")
end, { desc = "[r]efactor: [e]xtract function to [F]ile", expr = true })

vim.keymap.set({ "n", "x" }, "<leader>rev", function()
	return refactoring.refactor("Extract Variable")
end, { desc = "[r]efactor: [e]xtract [v]ariable", expr = true })
vim.keymap.set({ "n", "x" }, "<leader>rif", function()
	return refactoring.refactor("Inline Function")
end, { desc = "[r]efactor: [i]nline [f]unction", expr = true })
vim.keymap.set({ "n", "x" }, "<leader>riv", function()
	return refactoring.refactor("Inline Variable")
end, { desc = "[r]efactor: [i]nline [v]ariable", expr = true })

vim.keymap.set({ "n", "x" }, "<leader>reb", function()
	return refactoring.refactor("Extract Block")
end, { desc = "[r]efactor: [e]xtract [b]lock", expr = true })
