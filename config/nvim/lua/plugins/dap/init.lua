---@module "lazy"
---@type LazyPluginSpec
return {
	"mfussenegger/nvim-dap",
	version = false,
	lazy = true,
	desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",
	import = "plugins.dap",
}
