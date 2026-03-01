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
	diff_trunk_against_head = function(_)
		-- Find the default trunk branch name (e.g., "main" or "master")
		local trunk_out = run_cmd({ "git", "symbolic-ref", "--short", "refs/remotes/origin/HEAD" })

		local trunk = "master"
		if trunk_out ~= "" then
			trunk = vim.trim(trunk_out:gsub("^origin/", ""))
		end

		-- Find the current local branch
		local current_branch = vim.trim(run_cmd({ "git", "branch", "--show-current" }))

		-- Construct the diff command
		local args = { "git", "diff", "--no-ext-diff", "--no-color", "--unified=0", "--no-prefix" }

		if current_branch ~= trunk then
			table.insert(args, "origin/" .. trunk .. "...HEAD")
		else
			-- We are on the trunk branch, just diff against HEAD (uncommitted changes)
			table.insert(args, "HEAD")
		end

		return run_cmd(args)
	end,
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
