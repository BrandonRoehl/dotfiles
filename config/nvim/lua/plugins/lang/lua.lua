---@module "lazy"
---@return LazyPluginSpec[]
return {
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				-- { path = "luvit-meta/library", words = { "vim%.uv" } },
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "LazyVim", words = { "LazyVim" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
				{ path = "lazy.nvim", words = { "LazyVim" } },
				"nvim-dap-ui",
			},
		},
	},
	-- Extend
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = {
				"lua",
				"luadoc",
				"luap",
			},
		},
	},
	{
		"saghen/blink.cmp",
		optional = true,
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts_extend = { "completion.menu.draw.treesitter" },
		opts = {
			sources = {
				per_filetype = {
					lua = { "copilot", "lsp", "path", "snippets", "lazydev" },
				},
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 50,
					},
				},
			},
			completion = {
				menu = {
					draw = {
						treesitter = { "lazydev" },
					},
				},
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts_extend = { "servers", "ensure_installed" },
		opts = {
			servers = { "lua_ls" },
			ensure_installed = { "lua_ls" },
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		optional = true,
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = { "stylua" },
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
			},
		},
	},
}
