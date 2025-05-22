---@module "lazy"
---@type LazyPluginSpec
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		{ "mason-org/mason-lspconfig.nvim", dependencies = "mason-org/mason.nvim" },

		-- Allows extra capabilities provided by blink
		"saghen/blink.cmp",
	},
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
	config = function(_, opts)
		-- Mark what needs to be installed with Mason
		-- local ensure_installed = vim.tbl_filter(function(server)
		-- 	return not vim.tbl_contains(opts.exclude, server)
		-- end, opts.servers)
		require("mason-lspconfig").setup(
			---@type MasonLspconfigSettings
			{
				ensure_installed = opts.ensure_installed,
				automatic_enable = false,
			}
		)

		-- LSP servers and clients are able to communicate to each other what features they support.
		-- By default, Neovim doesn't support everything that is in the LSP specification.
		-- When you add blink-cmp, luasnip, etc. Neovim now has *more* capabilities.
		-- So, we create new capabilities with blink cmp, and then broadcast that to the servers.
		vim.lsp.config("*", {
			--- @type lsp.ClientCapabilities
			capabilities = vim.tbl_extend(
				"force",
				vim.lsp.protocol.make_client_capabilities(),
				require("blink.cmp").get_lsp_capabilities()
			),
		})
		vim.lsp.enable(opts.servers)
	end,
}
