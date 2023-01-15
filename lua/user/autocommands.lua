local group = vim.api.nvim_create_augroup("misc", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		local file_extension = vim.fn.expand("%:e")
		if file_extension ~= "diff" then
			vim.cmd(":keeppatterns:%s/\\s\\+$//e")
		end
	end,
	group = group,
	desc = "Trim trailing whitespace before save",
})
