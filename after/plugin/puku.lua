local puku_enabled = (vim.fn.executable("puku") == 1)

local group = vim.api.nvim_create_augroup("go", { clear = true })

local runPuku = function(args)
	-- don't run if puku is not enabled or if we are not in a plz repo
	if
		not puku_enabled
		or #vim.fs.find(".plzconfig", { upward = true, path = vim.api.nvim_buf_get_name(args.buf) }) < 1
	then
		return
	end

	-- make message more readable
	local function on_event(_, data)
		local msg = table.concat(data, "\n")
		msg = vim.trim(msg)
		msg = msg:gsub("\t", string.rep(" ", 4))
		if msg ~= "" then
			vim.notify("puku: " .. msg, vim.log.levels.INFO)
		end
	end

	vim.fn.jobstart({ "plz", "puku", "fmt", args.file }, {
		on_stdout = on_event,
		on_stderr = on_event,
		stdout_buffered = true,
		stderr_buffered = true,
	})
end

vim.api.nvim_create_autocmd("BufWritePost", {
	group = group,
	pattern = { "*.go" },
	desc = "Run puku on saved file if enabled",
	callback = runPuku,
})

vim.keymap.set("n", "<leader>ftp", function()
	if puku_enabled then
		vim.notify("Disabled puku format on save", vim.log.levels.INFO)
	else
		vim.notify("Enabled puku format on save", vim.log.levels.INFO)
	end
	puku_enabled = not puku_enabled
end, { desc = "[f]ormat on save [t]oggle [p]uku" })
