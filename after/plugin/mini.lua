-- gc keymaps for commenting
require('mini.comment').setup()

-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [']quote
--  - ci'  - [C]hange [I]nside [']quote
require('mini.ai').setup({ n_lines = 500 })

-- Some custom operators
require('mini.operators').setup({
  evaluate = { prefix = '' },
  exchange = { prefix = '' },
  multiply = { prefix = '' },
  replace = { prefix = '<leader>r' },
  sort = { prefix = '<leader>s' },
})

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [s]urround [a]dd [i]nner [w]ord [)]Paren
-- - sd'   - [s]urround [d]elete [']quotes
-- - sr)'  - [s]urround [r]eplace [)] [']
require('mini.surround').setup()

-- Simple and easy statusline.
--  You could remove this setup call if you don't like it,
--  and try some other statusline plugin
local statusline = require('mini.statusline')
-- set use_icons to true if you have a Nerd Font
statusline.setup({ use_icons = vim.g.have_nerd_font })

-- You can configure sections in the statusline by overriding their
-- default behavior. For example, here we set the section for
-- cursor location to LINE:COLUMN
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return '%2l:%-2v'
end

-- ... and there is more!
--  Check out: https://github.com/echasnovski/mini.nvim
