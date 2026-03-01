-- Insert-mode navigation
vim.keymap.set("i", "jj", "<esc>")
vim.keymap.set("i", "II", "<esc>I")
vim.keymap.set("i", "AA", "<esc>A")

-- Typing :wq and :q can be cumbersome.
-- Overload Ctrl-C to save modifiable buffers and quit from unmodifiable ones.
local quit_from_buftypes = {
	prompt = true,
	nowrite = true,
	nofile = true,
	help = true,
	quickfix = true,
}
vim.keymap.set("n", "<C-c>", function()
	local buftype = vim.api.nvim_get_option_value("buftype", {})
	if rawget(quit_from_buftypes, buftype) ~= nil then
		return vim.cmd("quit")
	end
	return vim.cmd("write")
end, { desc = "Save modifiable buffers, quit unmodifiable buffers" })
