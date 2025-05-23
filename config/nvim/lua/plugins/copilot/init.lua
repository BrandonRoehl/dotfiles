---@module "lazy"
---@return LazyPluginSpec
return {
	"github/copilot.vim",
	cmd = "Copilot",
	-- build = "<cmd>Copilot setup<cr>",
	desc = "Copilot in neovim for suggestions",
	event = { "BufWinEnter", "VeryLazy" },
	init = function()
		vim.g.copilot_filetypes = {
			["*"] = true,
			gitcommit = false,
			NeogitCommitMessage = false,
			DressingInput = false,
			TelescopePrompt = false,
			["neo-tree-popup"] = false,
			["dap-repl"] = false,
		}
		-- Disable the default mappings and key binds
		-- The one thing that needed to be added from blink-copilot
		vim.g.copilot_no_maps = true
	end,
	import = "plugins.copilot",
}
