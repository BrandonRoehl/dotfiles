---@module "lazy"
---@return LazyPluginSpec
return {
	"nvim-treesitter/nvim-treesitter-context",
	version = false,
	event = "VeryLazy",
	dependencies = "nvim-treesitter/nvim-treesitter",
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
	-- keys = {
	-- 	{
	-- 		"[c",
	-- 		function()
	-- 			require("treesitter-context").go_to_context()
	-- 		end,
	-- 		mode = "n",
	-- 		silent = true,
	-- 		desc = "Disable Context",
	-- 	},
	-- },
}
