-- /Users/akash/.config/nvim/after/plugin/statusline.lua
-- This file configures a custom statusline to truncate long git branch names.

-- Create a global table for our custom statusline functions
_G.custom_statusline = _G.custom_statusline or {}

-- Only set this if not using a dedicated statusline plugin
if vim.g.loaded_lualine then
	return
end

-- Define the function in the global table
function _G.custom_statusline.get_truncated_branch()
	-- Get the branch name from gitsigns' buffer variable
	local head = vim.b.gitsigns_head
	if not head then
		return ""
	end

	-- Define the maximum length for the branch name
	local max_len = 25
	if #head > max_len then
		-- Truncate and add an ellipsis if it's too long
		return " " .. string.sub(head, 1, max_len) .. "..."
	end

	return " " .. head
end

-- Set the global statusline
vim.o.statusline = ""
vim.o.statusline = vim.o.statusline .. "%#StatusLine#" -- Set the default highlight group
vim.o.statusline = vim.o.statusline .. "%f " -- Filename
vim.o.statusline = vim.o.statusline .. "%m" -- Modified flag
vim.o.statusline = vim.o.statusline .. "%=" -- Right-align the following components
vim.o.statusline = vim.o.statusline .. "%{get(b:,'gitsigns_status','')}" -- Git signs status (+~-)
vim.o.statusline = vim.o.statusline .. " "
vim.o.statusline = vim.o.statusline .. "%{luaeval('_G.custom_statusline.get_truncated_branch()')}"
vim.o.statusline = vim.o.statusline .. " "
vim.o.statusline = vim.o.statusline .. "%#StatusLineNC#" -- Switch to non-current window highlight
vim.o.statusline = vim.o.statusline .. "%l:%c " -- Line and column number
vim.o.statusline = vim.o.statusline .. "%P" -- Percentage through file
