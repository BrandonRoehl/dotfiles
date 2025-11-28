---@module "lazy"
---@return LazyPluginSpec
return {
	"olimorris/codecompanion.nvim",
	-- enabled = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		-- Progress options optional
		-- check the fidget config
		"j-hui/fidget.nvim",
	},
	config = true,
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
}
