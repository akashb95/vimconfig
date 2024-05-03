local osc52 = require("osc52")
local wk = require("which-key")

osc52.setup(
  { trim = true } -- Trim before copy
)

-- Now the '+' register will copy to system clipboard using OSC52
vim.keymap.set({ 'n', 'v' }, '<leader>c', '"+y')
vim.keymap.set('n', '<leader>cc', '"+yy')
