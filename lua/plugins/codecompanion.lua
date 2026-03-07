return {
	"olimorris/codecompanion.nvim",
	version = "v19.1.0",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim",
		"NotAShelf/direnv.nvim",
	},
	config = function()
		local codecompanion = require("codecompanion")

		local function get_git_root_or_cwd()
			return vim.fs.root(0, ".git") or vim.fn.getcwd()
		end

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
								api_key = "GEMINI_API_KEY",
							},
						})
					end,
				},
				acp = {
					gemini_cli = function()
						return require("codecompanion.adapters").extend("gemini_cli", {
							defaults = {
								auth_method = "gemini-api-key",
								mcpServers = "inherit_from_config",
							},
							env = {
								GEMINI_API_KEY = "GEMINI_API_KEY",
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
			mcp = {
				servers = {
					["filesystem"] = {
						cmd = {
							"npx",
							"-y",
							"@modelcontextprotocol/server-filesystem",
							get_git_root_or_cwd(),
						},
						roots = {
							get_git_root_or_cwd,
						},
						tool_overrides = {
							directory_tree = { opts = { require_approval_before = false } },
							get_file_info = { opts = { require_approval_before = false } },
							list_allowed_directories = { opts = { require_approval_before = false } },
							list_directory = { opts = { require_approval_before = false } },
							list_directory_with_sizes = { opts = { require_approval_before = false } },
							read_text_file = { opts = { require_approval_before = false } },
							read_multiple_files = { opts = { require_approval_before = false } },
							search_files = { opts = { require_approval_before = false } },
						},
					},
					["github"] = {
						cmd = { "npx", "-y", "@modelcontextprotocol/server-github" },
						env = {
							GITHUB_PERSONAL_ACCESS_TOKEN = "cmd:echo $GITHUB_PERSONAL_ACCESS_TOKEN",
						},
						tool_overrides = {
							actions_get = { opts = { require_approval_before = false } },
							actions_list = { opts = { require_approval_before = false } },
							get_commit = { opts = { require_approval_before = false } },
							get_dependabot_alert = { opts = { require_approval_before = false } },
							get_discussion = { opts = { require_approval_before = false } },
							get_discussion_comments = { opts = { require_approval_before = false } },
							get_file_contents = { opts = { require_approval_before = false } },
							get_gist = { opts = { require_approval_before = false } },
							get_global_security_advisory = { opts = { require_approval_before = false } },
							get_job_logs = { opts = { require_approval_before = false } },
							get_label = { opts = { require_approval_before = false } },
							get_latest_release = { opts = { require_approval_before = false } },
							get_me = { opts = { require_approval_before = false } },
							get_notification_details = { opts = { require_approval_before = false } },
							get_release_by_tag = { opts = { require_approval_before = false } },
							get_repository_tree = { opts = { require_approval_before = false } },
							get_tag = { opts = { require_approval_before = false } },
							get_team_members = { opts = { require_approval_before = false } },
							get_teams = { opts = { require_approval_before = false } },
							issue_read = { opts = { require_approval_before = false } },
							list_branches = { opts = { require_approval_before = false } },
							list_commits = { opts = { require_approval_before = false } },
							list_dependabot_alerts = { opts = { require_approval_before = false } },
							list_discussion_categories = { opts = { require_approval_before = false } },
							list_discussions = { opts = { require_approval_before = false } },
							list_gists = { opts = { require_approval_before = false } },
							list_global_security_advisories = { opts = { require_approval_before = false } },
							list_issue_types = { opts = { require_approval_before = false } },
							list_issues = { opts = { require_approval_before = false } },
							list_label = { opts = { require_approval_before = false } },
							list_notifications = { opts = { require_approval_before = false } },
							list_org_repository_security_advisories = { opts = { require_approval_before = false } },
							list_pull_requests = { opts = { require_approval_before = false } },
							list_releases = { opts = { require_approval_before = false } },
							list_repository_security_advisories = { opts = { require_approval_before = false } },
							list_starred_repositories = { opts = { require_approval_before = false } },
							list_tags = { opts = { require_approval_before = false } },
							projects_get = { opts = { require_approval_before = false } },
							projects_list = { opts = { require_approval_before = false } },
							pull_request_read = { opts = { require_approval_before = false } },
							search_code = { opts = { require_approval_before = false } },
						},
					},
					["memory"] = {
						cmd = { "npx", "-y", "@modelcontextprotocol/server-memory" },
					},
					["sequential-thinking"] = {
						cmd = { "npx", "-y", "@modelcontextprotocol/server-sequential-thinking" },
						tool_overrides = {
							sequential_thinking = {
								opts = {
									require_approval_before = false,
								},
							},
						},
					},
				},
				opts = {
					default_servers = { "filesystem", "memory", "sequential-thinking" },
				},
			},
			opts = {
				log_level = "INFO",
			},
			rules = {
				default = {
					description = "Collection of common files for all projects",
					files = {
						".clinerules",
						".cursorrules",
						".cursor/rules",
						".goosehints",
						".rules",
						".windsurfrules",
						".github/copilot-instructions.md",
						"AGENT.md",
						"AGENTS.md",
						{ path = "CLAUDE.md", parser = "claude" },
						{ path = "CLAUDE.local.md", parser = "claude" },
						{ path = "~/.claude/CLAUDE.md", parser = "claude" },
					},
				},
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
							tools = {
								"get_changed_files", -- To see what has changed in the git worktree
								"read_file", -- To read the full content of specific files
								"grep_search", -- To find occurrences of functions or variables
								"file_search", -- To find other relevant files in the project
								"run_command", -- To run any commands needed to get more context
								"get_diagnostics", -- To check for any LSP errors or warnings
								"mcp",
							},
							opts = {
								collapse_tools = false,
							},
						},
						["find_usages"] = {
							description = "An agent specialised in finding usages of symbols across repositories containing multiple languages",
							tools = {
								"read_file",
								"run_command",
								"get_diagnostics",
								"mcp",
							},
						},
					},
					keymaps = {
						send = {
							modes = { n = { "<C-c>", "<C-s>" }, i = "<C-s>" },
						},
						close = {
							modes = { n = "<C-q>", i = "<C-q>" },
						},
					},
					tools = {
						["file_search"] = {
							callback = "codecompanion.interactions.chat.tools.builtin.file_search",
							opts = {
								require_approval_before = false,
							},
						},
						["get_changed_files"] = {
							callback = "codecompanion.interactions.chat.tools.builtin.get_changed_files",
							opts = {
								require_approval_before = false,
							},
						},
						["get_diagnostics"] = {
							callback = "codecompanion.interactions.chat.tools.builtin.get_diagnostics",
							opts = {
								require_approval_before = false,
							},
						},
						["grep_search"] = {
							callback = "codecompanion.interactions.chat.tools.builtin.grep_search",
							opts = {
								require_approval_before = false,
							},
						},
						["memory"] = {
							callback = "codecompanion.interactions.chat.tools.builtin.memory",
							opts = {
								require_approval_before = false,
							},
						},
						["read_file"] = {
							callback = "codecompanion.interactions.chat.tools.builtin.read_file",
							opts = {
								require_approval_before = false,
							},
						},
						["run_command"] = {
							-- We must re-declare the callback to extend it
							callback = "codecompanion.interactions.chat.tools.builtin.run_command",
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
										"git show",
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

		vim.keymap.set(
			{ "n", "v" },
			"<Leader>ccy",
			"<cmd>CodeCompanionChat adapter=gemini_cli command=yolo<cr>",
			{ desc = "[c]ode[c]ompanion [y]olo mode (gemini_cli)", noremap = true, silent = true }
		)
	end,
}
