---@module "lazy"
---@return LazyPluginSpec[]
return {
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts = {
			opts_extend = { "ensure_installed" },
			ensure_installed = {
				"javascript",
				"typescript",
				"jsdoc",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts_extend = { "enable" },
		opts = {
			enable = {
				"ts_ls",
				"vue_ls",
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		optional = true,
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = { "ts_ls" },
		},
	},
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				-- You can use 'stop_after_first' to run the first available formatter from the list
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				vue = { "prettierd", "prettier", stop_after_first = true },
			},
		},
	},
}
