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
				auto_attach = function(bufnr)
					if #vim.bo[bufnr].buftype > 0 then
						return false
					end
					if vim.bo[bufnr].filetype ~= "rust" and not vim.fn.bufname(bufnr):match("Cargo%.toml$") then
						return false
					end

					return true
				end,
			},
			default_settings = {
				--- options to send to rust-analyzer
				--- See: https://rust-analyzer.github.io/book/configuration
				["rust-analyzer"] = {
					checkOnSave = {
						enable = false,
					},
					diagnostics = {
						enable = false, -- Do not double-up with Bacon LS
					},
				},
			},
			tools = {
				enable_clippy = false,
			},
		}
	end,
}
