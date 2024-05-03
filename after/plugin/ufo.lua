local ufo = require("ufo")
local wk = require("which-key")

ufo.setup()

wk.register({
  z = {
    name = "Fold",
    R = { ufo.openAllFolds(), "Open all folds" },
    M = { ufo.closeAllFolds(), "Close all folds" },
  }
})
