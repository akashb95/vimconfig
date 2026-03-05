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
					local root = vim.fs.root(filename, { "Cargo.toml", ".git" })
					if root then
						return root
					end
					return default_root_dir_func(filename)
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

        default_settings = {
          --- options to send to rust-analyzer
          --- See: https://rust-analyzer.github.io/book/configuration
          ["rust-analyzer"] = {
            check = {
              workspace = false,
            },
            -- checkOnSave = {
            	-- enable = false,
            -- },
            -- diagnostics = {
            	-- enable = false, -- Do not double-up with Bacon LS
            -- },
          },
        },
			},
			tools = {
				enable_clippy = false,
			},
		}
	end,
}
