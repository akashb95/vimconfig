local treesj = require("treesj")

treesj.setup({ use_default_keymaps = false })

vim.keymap.set("n", "<leader>cbt", treesj.toggle, { desc = "[c]hop [b]lock [t]oggle" })
vim.keymap.set("n", "<leader>cbs", treesj.split, { desc = "[c]hop [b]lock [s]plit" })
vim.keymap.set("n", "<leader>cbj", treesj.join, { desc = "[c]hop [b]lock [j]oin" })
vim.keymap.set("n", "<leader>cbrt", function()
	treesj.toggle({ split = { recursive = true } })
end, { desc = "[c]hop [b]lock [r]ecursive [t]oggle" })
