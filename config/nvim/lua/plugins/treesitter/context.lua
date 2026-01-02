---@module "lazy"
---@return LazyPluginSpec
return {
	"nvim-treesitter/nvim-treesitter-context",
	dependencies = "nvim-treesitter/nvim-treesitter",
	version = false,
	lazy = true,
	event = "VeryLazy",
	--- @type TSContext.UserConfig
	opts = {
		line_numbers = true,
		trim_scope = "outer",
		mode = "topline",
		-- https://neovim.io/doc/user/lua.html#vim.opt%3Aget()
		max_lines = vim.opt.scrolloff:get(),
		multiwindow = true,
	},
	commands = { "TSContextToggle", "TSContextEnable", "TSContextDisable" },
	keys = {
		{
			"[k",
			function()
				require("treesitter-context").go_to_context(vim.v.count1)
			end,
			mode = "n",
			silent = true,
			desc = "Go to context",
		},
	},
}
