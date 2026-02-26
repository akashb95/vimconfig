return {
  diff_master_against_head = function(args)
    return vim.system({ "git", "diff", "--no-ext-diff", "--no-color", "--unified=0", "--no-prefix", "master...HEAD" }, { text = true }):wait().stdout
  end,
}
