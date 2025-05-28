local wk = require("which-key")

wk.add({
  { "<leader>gs",  group = "Git" },
  { "<leader>gst", vim.cmd.Git,  desc = "Show status in new pane" },
  { "<leader>gb", "<CMD>Git blame<CR>", desc = "Blame" }
})

