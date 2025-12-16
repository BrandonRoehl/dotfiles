---@module "lazy"
---@return LazyPluginSpec[]
return {
	"neovim/nvim-lspconfig",
	optional = true,
	opts_extend = { "setup_extend" },
	opts = {
		---@type fun(self:LazyPlugin, opts:table)[]
		-- Will be executed when loading the plugin
		setup_extend = {
			function(_, _)
				require("plugins.lsp.progress.callbacks"):create_autocmds()
			end,
		},
	},
}
