local function run_cmd(cmd)
	if not cmd and not cmd[1] then
		-- In case input is empty
		return ""
	end

	-- Check whether executable exists in PATH
	if vim.fn.executable(cmd[1]) == 0 then
		return ""
	end

	local res = vim.system(cmd, { text = true }):wait()
	if res.code ~= 0 then
		-- Unsuccessful execution
		return ""
	end

	return res.stdout or ""
end

return {
	run_cmd = run_cmd,
	read_agents_md = function(_)
		return run_cmd({ "bat", "-p", "--paging=never", "--color=never", "AGENTS.md" })
	end,
	eza_help = function(_)
		return run_cmd({ "eza", "-h" })
	end,
	fd_help = function(_)
		return run_cmd({ "fd", "-h" })
	end,
	rg_help = function(_)
		return run_cmd({ "rg", "-h" })
	end,
}
