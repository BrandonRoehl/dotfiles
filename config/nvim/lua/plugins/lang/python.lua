---@module "lazy"
---@return LazyPluginSpec[]
return {
	{
		"mfussenegger/nvim-dap-python",
		enabled = Utils:is_computer("🔥"),
		version = false,
		lazy = true,
		event = "LazyDap",
		dependencies = {
			"mfussenegger/nvim-dap",
            -- stylua: ignore
            keys = {
                { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
                { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
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
				-- "pyrefly",
				"ruff",
			},
			ensure_installed = {
				"basedpyright",
				-- "pyrefly",
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
	--  optional = true,
	-- 	opts = {
	-- 		formatters_by_ft = {
	-- 			python = { "isort", "black" },
	-- 		},
	-- 	},
	-- },
}
