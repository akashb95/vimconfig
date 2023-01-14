local ufo = require("ufo")
vim.keymap.set('n', 'zR', ufo.openAllFolds)
vim.keymap.set('n', 'zM', ufo.closeAllFolds)
vim.keymap.set("n", "zp", ufo.peekFoldedLinesUnderCursor)

