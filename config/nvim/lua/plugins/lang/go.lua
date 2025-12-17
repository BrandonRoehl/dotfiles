---@module "lazy"
---@return LazyPluginSpec[]
return {
	{
		"leoluz/nvim-dap-go",
		version = false,
		lazy = true,
		enabled = Utils:enable_with("nvim-dap"),
		event = "LazyDap",
		dependencies = { "mfussenegger/nvim-dap", optional = true },
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
		opts_extend = { "servers" },
		opts = {
			servers = { "gopls" },
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		optional = true,
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = not Utils:is_win() and { "gopls" } or {},
		},
	},
}
