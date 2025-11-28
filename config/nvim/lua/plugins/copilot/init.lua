---@module "lazy"
---@return LazyPluginSpec
return {
	"neovim/nvim-lspconfig",
	import = "plugins.copilot",
	optional = true,
	opts_extend = { "servers", "ensure_installed" },
	opts = {
		servers = { "copilot" },
		ensure_installed = { "copilot" },
	},
}
