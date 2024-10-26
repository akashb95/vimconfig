local please = require("please")
local wk = require("which-key")

wk.add({
  { "<leader>p",  group = "Please" },
  { "<leader>pb", please.build,    desc = "Build" },
  {
    "<leader>pd",
    function() please.debug({ under_corsor = true }) end,
    desc = "[p]lease [d]ebug target under cursor using Delve (Go) or debugpy (Python)."
  },
  { "<leader>pj", please.jump_to_target,                             desc = "[p]lease [j]ump to BUILD target" },
  { "<leader>pm", please.maximise_popup,                             desc = "[p]lease [m]aximise popup" },
  { "<leader>pr", please.maximise_popup,                             desc = "[p]lease [r]estore popup. Note: use <leader>pm instead to maximise." },
  { "<leader>pt", function() please.test({ under_cursor = true }) end, desc = "[p]lease [t]est target under cursor" },
  { "<leader>py", please.yank,                                       desc = "[p]lease [y]ank target name, or name of target which takes current file in buffer as input" },
})
