---@module "lazy"
---@return LazyPluginSpec
return {
	"mfussenegger/nvim-dap",
	enabled = Utils:is_computer("🔥"),
	dependencies = {
		{ "mfussenegger/nvim-dap-python", version = false, lazy = true },
	},
	-- stylua: ignore
	keys = {
		{ "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
		{ "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
	},
	config = function()
		-- Python specific config
		require("dap-python").setup("python3")
	end,
}
