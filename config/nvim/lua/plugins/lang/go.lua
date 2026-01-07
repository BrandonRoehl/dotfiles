---@module "lazy"
---@return LazyPluginSpec[]
return {
	{
		"leoluz/nvim-dap-go",
		version = false,
		lazy = true,
		enabled = Utils.lazy:enable_with("nvim-dap"),
		event = "LazyDap",
		dependencies = { "mfussenegger/nvim-dap", optional = true },
		config = function()
			require("dap-go").setup({
				delve = {
					-- On Windows delve must be run attached or it crashes.
					-- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
					detached = not vim.fn.has("win32"),
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = { "go", "gomod", "gowork", "gosum" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts = {
			servers = { gopls = {} },
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		optional = true,
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = not vim.fn.has("win32") and { "gopls" } or {},
		},
	},
}
