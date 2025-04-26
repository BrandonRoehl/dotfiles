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
	-- Block highlights text detected as colors e.g. #ffffff
	-- Come back to this when this is added for real
	-- https://github.com/neovim/neovim/pull/33440
	{
		"brenoprata10/nvim-highlight-colors",
		event = "VeryLazy",
		version = "*",
		opts = {
			render = "virtual",
		},
	},
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",
}
