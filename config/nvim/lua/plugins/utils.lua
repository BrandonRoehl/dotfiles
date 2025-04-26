--- @module 'lazy'
--- @return LazyPluginSpec[]
return {
	-- Notifications provider
	{
		"j-hui/fidget.nvim",
		lazy = true,
		opts = {},
		config = function(_, opts)
			require("fidget").setup(opts)
			require("plugins.codecompanion.fidget-spinner"):init()
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = vim.g.have_nerd_font,
			keywords = {
				FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
				TODO = { icon = " ", color = "info" },
				HACK = { icon = " ", color = "warning" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
				PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				NOTE = { icon = " ", color = "hint", alt = { "INFO", "MARK" } },
				TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
			},
		},
	},
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",
}
