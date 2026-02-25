return {
  "ojroques/nvim-osc52",
  lazy = false,
  config = function()
    require("osc52").setup({
      silent = false,
      trim = false,
    })

    local function copy()
      if vim.v.event.operator == "y" and vim.v.event.regname == "" then
        require("osc52").copy_register('"')
      end
    end

    vim.api.nvim_create_autocmd("TextYankPost", { callback = copy })
  end
}
