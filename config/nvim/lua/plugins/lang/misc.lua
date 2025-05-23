---@module "lazy"
---@return LazyPluginSpec[]
return {
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"markdown",
				"markdown_inline",
				"printf",
				"query",
				"regex",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
				"rust",
				"ron",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts = {
			---@type string[]
			-- Enable the following language servers
			-- Feel free to add/remove any LSPs that you want here. They will automatically be installed.
			servers = {
				-- "pyright",
				"rust_analyzer",
				"sourcekit",
				"clangd",
				"ts_ls",
				"volar",
				-- "vale_ls",
				"harper_ls",
				"gdscript",
				"graphql",
				"texlab",
			},
			---@type string[]
			-- Servers to skip installing with mason
			ensure_installed = {
				"rust_analyzer",
				"ts_ls",
				"harper_ls",
				"texlab",
			},
		},
	},
}
