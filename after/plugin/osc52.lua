local osc52 = require("osc52")

osc52.setup({ trim = true }) -- Trim before copy

-- copy copies contents of register `"` to system clipboard when the
-- `d` or `y` operators are used.
local function copy()
  if (vim.v.event.operator == "y" or vim.v.event.operator == "d") and vim.v.event.regname == '"' then
    osc52.copy_register('"')
  end
end

vim.api.nvim_create_autocmd("TextYankPost", { callback = copy })
