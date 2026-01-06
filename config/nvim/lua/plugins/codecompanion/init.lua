---@module "lazy"
---@return LazyPluginSpec
return {
	"olimorris/codecompanion.nvim",
	enabled = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	lazy = true,
	cmd = {
		"CodeCompanion",
		"CodeCompanionChat",
		"CodeCompanionCmd",
		"CodeCompanionActions",
	},
	keys = {
		{ "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle Chat", mode = { "n", "v" } },
		{ "<leader>ap", "<cmd>CodeCompanionActions<cr>", desc = "Prompt Actions", mode = { "n", "v" } },
	},
	opts = {
		strategies = {
			chat = {
				name = "copilot",
				model = "gpt-4.1",
			},
			inline = {
				adapter = "copilot",
			},
		},
	},
	config = function(_, opts)
		require("codecompanion").setup(opts)
		-- Notification providers
		-- require("plugins.codecompanion.fidget-spinner"):init()
		-- require("plugins.codecompanion.progress-bar"):init()
		require("plugins.codecompanion.snacks-notify"):init()
	end,
}
