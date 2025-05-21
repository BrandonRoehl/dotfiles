---@module "lazy"
---@type LazyPluginSpec
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	desc = "A collection of small QoL plugins for Neovim",
	import = "plugins.snacks",
}
