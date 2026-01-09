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
				"make",
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
				"swift",
				"graphql",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts = {
			servers = {
				sourcekit = {},
				clangd = {},
				harper_ls = {},
				gdscript = {},
				graphql = {},
				texlab = {},
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		optional = true,
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = {
				"harper_ls",
				"texlab",
			},
		},
	},
}
