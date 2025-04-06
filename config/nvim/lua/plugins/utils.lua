--- @module 'lazy'
--- @return LazyPluginSpec[]
return {
	-- Notifications provider
	{
		"j-hui/fidget.nvim",
		version = "*",
		lazy = true,
		opts = {},
		config = function(_, opts)
			require("fidget").setup(opts)
			require("plugins.codecompanion.fidget-spinner"):init()
		end,
	},
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",
}
