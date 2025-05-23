---@module "lazy"
---@return LazyPluginSpec[]
return {
	{
		"mfussenegger/nvim-dap",
		optional = true,
		enabled = Utils:is_computer("🔥"),
		dependencies = {
			{
				"mfussenegger/nvim-dap-python",
				version = false,
				lazy = true,
				config = function()
					-- Python specific config
					require("dap-python").setup("python3")
				end,
			},
		},
        -- stylua: ignore
        keys = {
            { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
            { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
        },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts = {
			opts_extend = { "ensure_installed" },
			ensure_installed = { "python" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts_extend = { "servers", "ensure_installed" },
		opts = {
			servers = {
				-- "pyright",
				"basedpyright",
				"ruff",
			},
			ensure_installed = {
				"basedpyright",
				"ruff",
			},
		},
	},
	-- This has been replaced by Ruff
	-- {
	-- 	"WhoIsSethDaniel/mason-tool-installer.nvim",
	-- 	optional = true,
	--  opts_extend = { "ensure_installed" },
	-- 	opts = {
	-- 		ensure_installed = {
	-- 			"black", -- Used to format Python code
	-- 			"isort", -- Used to sort Python imports
	-- 		},
	-- 	},
	-- },
	-- {
	-- 	"stevearc/conform.nvim",
	-- 	opts = {
	-- 		formatters_by_ft = {
	-- 			python = { "isort", "black" },
	-- 		},
	-- 	},
	-- },
}
