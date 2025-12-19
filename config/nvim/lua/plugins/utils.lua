---@module "lazy"
---@return LazyPluginSpec[]
return {
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
		-- keys = {
		-- 	{
		-- 		"<leader>st",
		-- 		function()
		-- 			Snacks.picker.todo_comments()
		-- 		end,
		-- 		desc = "Todo",
		-- 	},
		-- 	{
		-- 		"<leader>sT",
		-- 		function()
		-- 			Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
		-- 		end,
		-- 		desc = "Todo/Fix/Fixme",
		-- 	},
		-- },
	},
}
