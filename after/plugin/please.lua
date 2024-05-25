local please = require("please")
local wk = require("which-key")

wk.register({
  ["<leader>p"] = {
    name = "Please",
    b = {
      please.build,
      "Build",
    },
    d = {
      function() please.debug({ under_cursor = true }) end,
      "[p]lease [d]ebug target under cursor using Delve (Go) or debugpy (Python)."
    },
    j = { please.jump_to_target, "[p]lease [j]ump to BUILD target" },
    r = { please.maximise_popup, "[p]lease [r]estore popup. Note: use <leader>pm instead to maximise." },
    m = { please.maximise_popup, "[p]lease [m]aximise popup" },
    t = {
      function() please.test({ under_cursor = true }) end,
      "[p]lease [t]est target under cursor",
    },
    y = {
      please.yank, "[p]lease [y]ank target name, or name of target which takes current file in buffer as input"
    }
  },
})
