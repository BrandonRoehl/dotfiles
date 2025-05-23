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
			ensure_installed = { "python" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		optional = true,
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
}
