local function open_yazi(data)
	-- Check if the buffer is a directory
	if vim.fn.isdirectory(data.file) ~= 1 then
		return
	end

	-- Schedule this to run on the "main loop" just after startup.
	-- This is safer than running it directly in the autocmd.
	vim.schedule(function()
		-- Run :Yazi, then chain the :bdelete# command.
		-- :bdelete# deletes the "alternate" buffer, which in this
		-- case is the netrw/directory buffer we just came from.
		vim.cmd("Yazi")
		vim.cmd("bdelete#")
	end)
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_yazi })
