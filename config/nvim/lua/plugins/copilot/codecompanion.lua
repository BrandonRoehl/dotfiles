---@module "lazy"
---@return LazyPluginSpec
return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		-- Copilot authorization
		"github/copilot.vim",
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
				adapter = "copilot",
			},
			inline = {
				adapter = "copilot",
			},
		},
		show_defaults = false,
		adapters = {
			copilot = function()
				-- lua print(vim.inspect(require("codecompanion.adapters").extend("copilot").schema.model.choices()))
				local adapters = require("codecompanion.adapters")
				return adapters.extend("copilot", {
					schema = {
						model = {
							default = "claude-3.7-sonnet",
						},
					},
				})
			end,
		},
	},
}
