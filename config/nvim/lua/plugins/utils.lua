---@module "lazy"
---@return LazyPluginSpec[]
return {
	-- Notifications provider
	{
		"j-hui/fidget.nvim",
		lazy = true,
		opts = {},
		config = function(_, opts)
			require("fidget").setup(opts)
			require("codecompanion.fidget-spinner"):init()
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
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
	-- Block highlights text detected as colors e.g. #ffffff
	-- Come back to this when this is added for real
	-- https://github.com/neovim/neovim/pull/33440
	{
		"brenoprata10/nvim-highlight-colors",
		event = "VeryLazy",
		opts = {
			render = "virtual",
		},
	},
	-- Ensure the servers and tools above are installed
	--  To check the current status of installed tools and/or manually install
	--  other tools, you can run
	--    :Mason
	--
	--  You can press `g?` for help in this menu.
	-- require("mason").setup()
	--- @type LazyPluginSpec
	{
		"williamboman/mason.nvim",
		config = true,
		lazy = true,
		build = ":MasonUpdate",
		cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
		--- @module 'mason'
		--- @class MasonSettings
		opts = {
			ui = {
				border = vim.g.border,
				-- icons = {},
			},
		},
	},
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",
}
