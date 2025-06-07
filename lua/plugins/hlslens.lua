return {
	"kevinhwang91/nvim-hlslens",
	config = function()
		local ok, scrollbar_search = pcall(require, "scrollbar.handlers.search")
		if ok then
			scrollbar_search.setup({
				calm_down = true,
			})
		end
	end,
	opts = {},
}
