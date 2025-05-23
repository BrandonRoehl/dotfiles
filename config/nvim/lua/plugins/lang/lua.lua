---@module "lazy"
---@return LazyPluginSpec[]
return {
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts = {
			ensure_installed = {
				"lua",
				"luadoc",
				"luap",
			},
		},
	},
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
	{
		"saghen/blink.cmp",
		optional = true,

		-- These will extend the base configuration
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
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
}
