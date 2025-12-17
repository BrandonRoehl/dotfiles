---@module "lazy"
---@return LazyPluginSpec
return {
	{
		"folke/sidekick.nvim",
		event = { "BufWinEnter", "VeryLazy" },
		opts = {
			-- add any options here
			cli = {
				mux = {
					backend = "tmux",
					enabled = true,
				},
			},
		},
		keys = {
			{
				"<tab>",
				function()
					-- if there is a next edit, jump to it, otherwise apply it if any
					if not require("sidekick").nes_jump_or_apply() then
						return "<Tab>" -- fallback to normal tab
					end
				end,
				expr = true,
				desc = "Goto/Apply Next Edit Suggestion",
			},
			-- {
			-- 	"<c-.>",
			-- 	function()
			-- 		require("sidekick.cli").toggle()
			-- 	end,
			-- 	desc = "Sidekick Toggle",
			-- 	mode = { "n", "t", "i", "x" },
			-- },
			-- {
			-- 	"<leader>aa",
			-- 	function()
			-- 		require("sidekick.cli").toggle()
			-- 	end,
			-- 	desc = "Sidekick Toggle CLI",
			-- },
			-- {
			-- 	"<leader>as",
			-- 	function()
			-- 		require("sidekick.cli").select()
			-- 	end,
			-- 	-- Or to select only installed tools:
			-- 	-- require("sidekick.cli").select({ filter = { installed = true } })
			-- 	desc = "Select CLI",
			-- },
			-- {
			-- 	"<leader>ad",
			-- 	function()
			-- 		require("sidekick.cli").close()
			-- 	end,
			-- 	desc = "Detach a CLI Session",
			-- },
			-- {
			-- 	"<leader>at",
			-- 	function()
			-- 		require("sidekick.cli").send({ msg = "{this}" })
			-- 	end,
			-- 	mode = { "x", "n" },
			-- 	desc = "Send This",
			-- },
			-- {
			-- 	"<leader>af",
			-- 	function()
			-- 		require("sidekick.cli").send({ msg = "{file}" })
			-- 	end,
			-- 	desc = "Send File",
			-- },
			-- {
			-- 	"<leader>av",
			-- 	function()
			-- 		require("sidekick.cli").send({ msg = "{selection}" })
			-- 	end,
			-- 	mode = { "x" },
			-- 	desc = "Send Visual Selection",
			-- },
			-- {
			-- 	"<leader>ap",
			-- 	function()
			-- 		require("sidekick.cli").prompt()
			-- 	end,
			-- 	mode = { "n", "x" },
			-- 	desc = "Sidekick Select Prompt",
			-- },
		},
	},
	{
		"saghen/blink.cmp",
		optional = true,
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				["<Tab>"] = {
					function() -- sidekick next edit suggestion
						return require("sidekick").nes_jump_or_apply()
					end,
					function(cmp)
						if cmp.snippet_active() then
							return cmp.accept()
						else
							return cmp.select_and_accept()
						end
					end,
					"snippet_forward",
					"fallback",
				},
			},
		},
	},
}
