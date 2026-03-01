return {
	"olimorris/codecompanion.nvim",
	version = "v18.7.0",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		local codecompanion = require("codecompanion")

		codecompanion.setup({
			adapters = {
				http = {
					gemini = function()
						return require("codecompanion.adapters").extend("gemini", {
							schema = {
								model = {
									default = "gemini-3.1-pro-preview",
								},
							},
							env = {
								api_key = "cmd:op read op://Employee/ukafu5czkq37oo7thictjenh4e/credential --no-newline",
							},
						})
					end,
				},
			},
			display = {
				diff = {
					enabled = true,
					provider = require("codecompanion.providers").diff,
				},
			},
			opts = {
				log_level = "INFO",
			},
			prompt_library = {
				markdown = {
					dirs = {
						vim.fn.stdpath("config") .. "/lua/plugins/codecompanion_prompts",
					},
				},
			},
			interactions = {
				chat = {
					adapter = "gemini",
					groups = {
						["code_reviewer"] = {
							description = "An agent specialised in reviewing code changes.",
							system_prompt = "You are an senior engineer who is reviewing code. Your goal is to analyze the user's code changes and provide candid and constructive feedback. Use the provided tools to understand the context of the changes, find related code, and read relevant files.",
							tools = {
								"get_changed_files", -- To see what has changed in the git worktree
								"read_file", -- To read the full content of specific files
								"grep_search", -- To find occurrences of functions or variables
								"list_code_usages", -- To understand symbol usages via LSP
								"file_search", -- To find other relevant files in the project
								"cmd_runner", -- To run any commands needed to get more context
							},
							opts = {
								collapse_tools = false,
							},
						},
						["find_usages"] = {
							tools = {
								"read_file",
								"list_code_usages",
								"cmd_runner",
							},
						},
					},
					keymaps = {
						send = {
							modes = { n = "<C-c>", i = "<C-s>" },
						},
						close = {
							modes = { n = "<C-q>", i = "<C-q>" },
						},
					},
					tools = {
						-- Extend the built-in cmd_runner tool
						["cmd_runner"] = {
							-- We must re-declare the callback to extend it
							callback = "codecompanion.interactions.chat.tools.builtin.cmd_runner",
							description = "Run shell commands on the user's system",
							opts = {
								---
								-- This function decides whether to prompt for approval.
								-- @param tool table The tool object with args from the LLM.
								-- @return boolean `true` to require approval, `false` to run automatically.
								---
								require_approval_before = function(tool)
									-- Define a list of safe, "read-only" command prefixes.
									-- Be very careful what you add here!
									local read_only_commands = {
										"bat",
										"cat",
										"eza",
										"find",
										"fd",
										"git diff",
										"git status",
										"git log",
										"grep",
										"ls",
										"rg",
										"tree",
									}

									local command_to_run = tool.args and tool.args.cmd

									if not command_to_run then
										-- If we can't determine the command, be safe and ask.
										return true
									end

									-- Check if the command starts with one of our safe prefixes.
									for _, safe_cmd in ipairs(read_only_commands) do
										-- The '^' ensures we only match the start of the command.
										if string.find(command_to_run, "^" .. safe_cmd) then
											vim.notify(
												"Auto-approving read-only command: " .. command_to_run,
												vim.log.levels.INFO
											)
											return false -- Do not require approval.
										end
									end

									-- If it's not in our safe list, require approval.
									return true
								end,
							},
						},
					},
				},
				inline = {
					adapter = "gemini",
				},
				cmd = {
					adapter = "gemini",
				},
			},
		})

		vim.keymap.set(
			{ "n" },
			"<Leader>cci",
			"<cmd>CodeCompanion<cr>",
			{ desc = "[c]ode[c]ompanion [c]hat [i]nline", noremap = true, silent = true }
		)

		vim.keymap.set(
			{ "n" },
			"<Leader>cco",
			"<cmd>CodeCompanionChat<cr>",
			{ desc = "[c]ode[c]ompanion [c]hat [o]pen", noremap = true, silent = true }
		)

		vim.keymap.set(
			{ "n" },
			"<Leader>cct",
			"<cmd>CodeCompanionChat Toggle<cr>",
			{ desc = "[c]ode[c]ompanion [c]hat [t]oggle", noremap = true, silent = true }
		)

		vim.keymap.set(
			{ "n", "v" },
			"<Leader>cca",
			"<CMD>CodeCompanionActions<CR>",
			{ desc = "[c]ode[c]ompanion [a]ctions", noremap = true, silent = true }
		)
	end,
}
