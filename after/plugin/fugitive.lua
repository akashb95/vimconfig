local wk = require("which-key")

wk.register({
  ["<leader>gs"] = {
    name = "Git",
    t = { vim.cmd.Git, "Show status in new pane" }
  },
  ["g"] = {
    name = "select change",
    r = { ":call diffget //2<CR>" },
    l = { ":call diffget //3<CR>" },
  },
})

vim.keymap.set("n", "gl", "<cmd> diffget //2<CR>")
vim.keymap.set("n", "gr", "<cmd> diffget //3<CR>")
