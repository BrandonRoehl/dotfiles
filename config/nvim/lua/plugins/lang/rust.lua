---@module "lazy"
---@return LazyPluginSpec[]
return {
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts = {
			ensure_installed = { "rust", "ron" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts = {
			servers = {
				rust_analyzer = {
					keys = {
						{
							"<leader>cx",
							function()
								vim.print("Expanding macro...")
								-- test
								vim.lsp.buf_request_all(
									0,
									"rust-analyzer/expandMacro",
									vim.lsp.util.make_position_params(),
									function(results)
										-- Print the macro expansion JSON payload into messages
										vim.print(results)
									end
								)
							end,
							desc = "Expand macro",
						},
					},
				},
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		optional = true,
		opts = {
			ensure_installed = { "rust_analyzer" },
		},
	},
	-- {
	-- 	"mason-org/mason.nvim",
	-- 	optional = true,
	-- 	opts = {
	-- 		ensure_installed = { "rustfmt" },
	-- 	},
	-- },
	-- {
	-- 	"stevearc/conform.nvim",
	-- 	optional = true,
	-- 	opts = {
	-- 		formatters_by_ft = {
	-- 			rust = { "rustfmt" },
	-- 		},
	-- 	},
	-- },
}
