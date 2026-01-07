---@module "lazy"
---@return LazyPluginSpec[]
return {
	{
		"mfussenegger/nvim-dap-python",
		enabled = function()
			return Utils.lazy:has_plugin("nvim-dap") and Utils.computer:is_host("🔥")
		end,
		version = false,
		lazy = true,
		event = "LazyDap",
		dependencies = {
			"mfussenegger/nvim-dap",
            -- stylua: ignore
            keys = {
                { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
                { "<leader>dPc", function() require('dap-python').test_class() end,  desc = "Debug Class",  ft = "python" },
            },
		},
		config = function()
			-- Python specific config
			require("dap-python").setup("uv")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = { "python" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts = {
			servers = {
				-- pyright = {},
				basedpyright = {},
				-- pyrefly = {},
				ruff = {
                    -- stylua: ignore
					keys = {
						{ "<leader>co", Utils.lsp.action["source.organizeImports"], desc = "Organize Imports" },
					},
					capabilities = {
						hoverProvider = false,
					},
				},
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		optional = true,
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = {
				"basedpyright",
				-- "pyrefly",
				"ruff",
			},
		},
	},
}
