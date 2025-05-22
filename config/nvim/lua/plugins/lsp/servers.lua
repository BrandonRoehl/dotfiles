---@module "lazy"
---@type LazyPluginSpec
return {
	"neovim/nvim-lspconfig",
	opts = {
		---@type string[]
		-- Enable the following language servers
		-- Feel free to add/remove any LSPs that you want here. They will automatically be installed.
		servers = {
			-- "pyright",
			"basedpyright",
			"ruff",
			"rust_analyzer",
			"gopls",
			"sourcekit",
			"clangd",
			"ts_ls",
			"volar",
			"lua_ls",
			-- "vale_ls",
			"harper_ls",
			"gdscript",
			"graphql",
			"texlab",
		},
		---@type string[]
		-- Servers to skip installing with mason
		ensure_installed = Utils:is_win() and {
			"basedpyright",
			"ruff",
			"rust_analyzer",
			"ts_ls",
			"harper_ls",
			"texlab",
		} or {
			"basedpyright",
			"ruff",
			"rust_analyzer",
			"ts_ls",
			"harper_ls",
			"texlab",
			"gopls",
		},
	},
}
