require("sourcegraph").setup(
  {
    api_url = "https://sourcegraph.internal.tmachine.io/.api",
    api_token = "9706e42783e62759cf6010720be25275fb9c5b4b",
  }
)

-- TM specific config to pop `/core3` from Git url
require("telescope").setup {
  extensions = {
    sourcegraph = {
      query_prefix_function = function()
        local query = vim.fn["sourcegraph#construct_local_repo_query"]()
        return string.gsub(query, "/[^/$]*[$]", "")
      end
    },
  },
}

require("telescope").load_extension("sourcegraph")

vim.keymap.set("n", "<leader>tsg", ":SourceGraphRaw ")
