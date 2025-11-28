return {
	"mrcjkb/rustaceanvim",
	version = "^6", -- Recommended
	lazy = false, -- This plugin is already lazy
	ft = { "rust" },
	init = function()
		vim.g.rustaceanvim = {
			server = {
				-- Configure the root_dir to find the nearest Cargo.toml or .git directory
				root_dir = function(filename, default_root_dir_func)
					local current_buffer_dir = vim.fs.dirname(filename)
					local found_root = vim.fs.find({ "Cargo.toml", ".git" }, {
						upward = true,
						path = current_buffer_dir,
						type = "file",
					})

					if #found_root > 0 then
						-- Return the directory of the found file/directory
						return vim.fs.dirname(found_root[1])
					else

          -- Fallback to the default root_dir calculation if nothing is found
          return default_root_dir_func(filename)

					end
				end,
			},
      tools = {
        enable_clippy=false,
      },
		}
	end,
}
