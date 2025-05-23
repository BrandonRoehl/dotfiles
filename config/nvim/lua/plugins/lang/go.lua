---@module "lazy"
---@return LazyPluginSpec[]
return {
	{
		"mfussenegger/nvim-dap",
		optional = true,
		enabled = true,
		dependencies = {
			{
				"leoluz/nvim-dap-go",
				version = false,
				lazy = true,
				config = function()
					require("dap-go").setup({
						delve = {
							-- On Windows delve must be run attached or it crashes.
							-- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
							detached = not Utils:is_win(),
						},
					})
				end,
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = { "go" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts_extend = { "servers", "ensure_installed" },
		opts = {
			servers = { "gopls" },
			ensure_installed = not Utils:is_win() and { "gopls" } or {},
		},
	},
}
