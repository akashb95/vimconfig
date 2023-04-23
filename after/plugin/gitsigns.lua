local gitsigns = require("gitsigns")
local wk = require("which-key")

-- Reduce nesting because of WhichKey.
local function on_attach(bufnr)
  vim.keymap.set(
    "n",
    "]c",
    function()
      if vim.wo.diff then return "]c" end
      vim.schedule(function() gitsigns.next_hunk() end)
      return "<Ignore>"
    end,
    { expr = true, buffer = bufnr }
  )
  vim.keymap.set(
    "n",
    "[c",
    function()
      if vim.wo.diff then return "[c" end
      vim.schedule(function() gitsigns.prev_hunk() end)
      return "<Ignore>"
    end,
    { expr = true, buffer = bufnr }
  )

  wk.register({
    ["<leader>h"] = {
      "Gitsigns",
      d = { gitsigns.diffthis, "diff" },
      D = { function() gitsigns.diffthis("~") end, "Diff against head" },
      r = { gitsigns.reset_hunk, "reset hunk" },
      R = { gitsigns.reset_buffer, "reset buffer" },
      s = { gitsigns.stage_hunk, "stage hunk" },
    }
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
