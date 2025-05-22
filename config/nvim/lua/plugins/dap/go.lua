-- DAP Plugins
---@module "lazy"
---@return LazyPluginSpec
return {
	"mfussenegger/nvim-dap",
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
						detached = vim.fn.has("win32") == 0,
					},
				})
			end,
		},
	},
}
