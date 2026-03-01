local common = require("plugins.codecompanion_prompts.common")
local run_cmd = common.run_cmd

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
}
