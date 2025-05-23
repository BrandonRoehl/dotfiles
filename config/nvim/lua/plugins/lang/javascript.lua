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
		opts_extend = { "servers", "ensure_installed" },
		opts = {
			servers = {
				"ts_ls",
				"volar",
			},
			ensure_installed = { "ts_ls" },
		},
	},
	{
		"stevearc/conform.nvim",
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
