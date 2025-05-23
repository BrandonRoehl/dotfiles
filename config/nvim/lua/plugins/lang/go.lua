-- DAP Plugins
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
							detached = Utils:is_win() or vim.fn.has("win32") == 0,
						},
					})
				end,
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts = {
			ensure_installed = { "go" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts = {
			servers = { "gopls" },
			ensure_installed = not Utils:is_win() and { "gopls" } or {},
		},
	},
}
