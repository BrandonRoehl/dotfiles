---@module "lazy"
---@return LazyPluginSpec[]
return {
	"neovim/nvim-lspconfig",
	optional = true,
	opts_extend = { "extend_config" },
	opts = {
		---@type fun(self:LazyPlugin, opts:table)[]
		-- Will be executed when loading the plugin
		extend_config = {
			function(_, _)
				require("plugins.lsp.progress.callbacks"):create_autocmds()
			end,
		},
	},
}
