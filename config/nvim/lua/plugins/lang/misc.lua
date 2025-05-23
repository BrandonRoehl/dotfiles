---@module "lazy"
---@return LazyPluginSpec[]
return {
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"json",
				"jsonc",
				"markdown",
				"markdown_inline",
				"printf",
				"query",
				"regex",
				"toml",
				"tsx",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts_extend = { "servers", "ensure_installed" },
		opts = {
			servers = {
				"sourcekit",
				"clangd",
				"harper_ls",
				"gdscript",
				"graphql",
				"texlab",
			},
			ensure_installed = {
				"harper_ls",
				"texlab",
			},
		},
	},
}
