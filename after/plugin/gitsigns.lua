local gitsigns = require("gitsigns")
local wk = require("which-key")

local function on_attach(bufnr)
  -- Navigation shortcuts
  vim.keymap.set(
    "n",
    "]c",
    function()
      if vim.wo.diff then return "]c" end
      vim.schedule(function() gitsigns.next_hunk() end)
      return "<Ignore>"
    end,
    { expr = true, buffer = bufnr, desc = "jump to next hunk" }
  )
  vim.keymap.set(
    "n",
    "[c",
    function()
      if vim.wo.diff then return "[c" end
      vim.schedule(function() gitsigns.prev_hunk() end)
      return "<Ignore>"
    end,
    { expr = true, buffer = bufnr, desc = "jump to prev hunk" }
  )

  wk.add({
    { "<leader>g",   group = "[G]it" },
    { "<leader>gd",  gitsigns.diffthis,                     desc = "[d]iff" },
    { "<leader>gD",  function() gitsigns.diffthis("~") end, desc = "[D]iff against head" },
    { "<leader>gr",  gitsigns.reset_hunk,                   desc = "[r]eset hunk" },
    { "<leader>gr",  gitsigns.reset_buffer,                 desc = "[R]eset buffer" },
    { "<leader>gsb", gitsigns.stage_buffer,                 desc = "[s]tage [b]uffer" },
    { "<leader>gsh", gitsigns.stage_hunk,                   desc = "[s]tage [h]unk" },
  })
end

gitsigns.setup({
  update_debounce = 1000,
  current_line_blame_opts = {
    virt_text = false,
    virt_text_pos = "right_align",
    ignore_whitespace = true,
  },
  on_attach = on_attach,
})
