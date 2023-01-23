local ufo = require("ufo")
local hlslens = require("hlslens")

vim.keymap.set('n', 'zR', ufo.openAllFolds)
vim.keymap.set('n', 'zM', ufo.closeAllFolds)
vim.keymap.set("n", "zp", ufo.peekFoldedLinesUnderCursor)

local function nN(char)
    local ok, winid = hlslens.nNPeekWithUFO(char)
    if ok and winid then
        -- Safe to override buffer scope keymaps remapped by ufo,
        -- ufo will restore previous buffer keymaps before closing preview window
        -- Type <CR> will switch to preview window and fire `trace` action
        vim.keymap.set('n', '<CR>', function()
            local keyCodes = vim.api.nvim_replace_termcodes('<Tab><CR>', true, false, true)
            vim.api.nvim_feedkeys(keyCodes, 'im', false)
        end, {buffer = true})
    end
end

vim.keymap.set({'n', 'x'}, 'n', function() nN('n') end)
vim.keymap.set({'n', 'x'}, 'N', function() nN('N') end)
