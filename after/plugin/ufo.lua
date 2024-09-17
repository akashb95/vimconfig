local ufo = require("ufo")
local wk = require("which-key")

ufo.setup()

wk.add({
  { "z",  group = "Fold" },
  { "zR", ufo.openAllFolds,  desc = "[R]eset (open all folds)" },
  { "zM", ufo.closeAllFolds, desc = "[M]inimize (close all folds)" },
})
