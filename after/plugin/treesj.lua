local treesj = require("treesj")
local wk = require("which-key")

treesj.setup({})

wk.add({
  { "<leader>t",  group = "Split/Join node" },
  { "<leader>tt", treesj.toggle,            desc = "[t]oggle split/join" },
  { "<leader>tj", treesj.join,              desc = "[j]oin node" },
  { "<leader>ts", treesj.split,             desc = "[s]plit node" },
})
