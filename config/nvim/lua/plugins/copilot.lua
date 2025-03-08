--- @module 'lazy'
--- @return LazyPluginSpec[]
return {
	{
		"github/copilot.vim",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "BufWinEnter",
		version = "*",
		init = function()
			vim.g.copilot_no_maps = true
		end,
		config = function()
			-- Block the normal Copilot suggestions
			-- This setup and the callback is required for
			-- https://github.com/fang2hou/blink-copilot
			vim.api.nvim_create_augroup("github_copilot", { clear = true })
			for _, event in pairs({ "FileType", "BufUnload", "BufEnter" }) do
				vim.api.nvim_create_autocmd({ event }, {
					group = "github_copilot",
					callback = function()
						vim.fn["copilot#On" .. event]()
					end,
				})
			end
			vim.g.copilot_filetypes = {
				["*"] = true,
				gitcommit = false,
				NeogitCommitMessage = false,
				DressingInput = false,
				TelescopePrompt = false,
				["neo-tree-popup"] = false,
				["dap-repl"] = false,
			}
		end,
	},
	{
		"olimorris/codecompanion.nvim",
		version = "*",
		enabled = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			-- Progress options optional
			"j-hui/fidget.nvim",
		},
		config = true,
		cmd = {
			"CodeCompanion",
			"CodeCompanionChat",
			"CodeCompanionCmd",
			"CodeCompanionActions",
		},
		keys = {
			{ "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle Chat", mode = { "n", "v" } },
			{ "<leader>ap", "<cmd>CodeCompanionActions<cr>", desc = "Actions", mode = { "n", "v" } },
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
		init = function()
			require("plugins.codecompanion.fidget-spinner"):init()
		end,
	},
}
