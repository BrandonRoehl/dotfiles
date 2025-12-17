---@module "lazy"
---@return LazyPluginSpec
return {
	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts_extend = { "servers", "ensure_installed" },
		opts = {
			servers = { "copilot" },
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		optional = true,
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = { "copilot" },
		},
	},
	{
		import = "plugins.copilot",
	},
}
