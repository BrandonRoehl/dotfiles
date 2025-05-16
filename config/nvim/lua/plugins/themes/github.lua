---@module "lazy"
---@return LazyPluginSpec
return {
	"projekt0n/github-nvim-theme",
	name = "github-theme",
	enabled = true,
	lazy = false,
	priority = 1000,
	opts = {
		-- ...
	},
	config = function(_, opts)
		require("github-theme").setup(opts)
	end,
	init = function()
		vim.cmd.colorscheme("github_dark_default")
	end,
}
