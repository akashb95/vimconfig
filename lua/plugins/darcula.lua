function ColourMyPencils(colour)
	colour = colour or "darcula-solid"
	vim.cmd.colorscheme(colour)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
  'briones-gabriel/darcula-solid.nvim',
  dependencies = { 'rktjmp/lush.nvim' },

  lazy = false,
  priority = 100,

  config = function ()
    vim.cmd("colorscheme darcula-solid")
    vim.cmd("set termguicolors")
    ColourMyPencils("darcula-solid")
  end,

  opts = {},
}
