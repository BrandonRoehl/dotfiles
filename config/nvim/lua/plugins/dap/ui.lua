---@module "lazy"
---@type LazyPluginSpec
return {
	"rcarriga/nvim-dap-ui",
	version = false,
	dependencies = { "nvim-neotest/nvim-nio" },
		-- stylua: ignore
		keys = {
			{ "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
			{ "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
		},
	-- For more information, see |:help nvim-dap-ui|
	--- @type dapui.Config
	opts = {
		-- Set icons to characters that are more likely to work in every terminal.
		--    Feel free to remove or use ones that you like more! :)
		--    Don't feel like these are good choices.
		icons = vim.g.have_nerd_font and {} or { expanded = "▾", collapsed = "▸", current_frame = "*" },
		controls = {
			icons = vim.g.have_nerd_font and {} or {
				pause = "⏸",
				play = "▶",
				step_into = "⏎",
				step_over = "⏭",
				step_out = "⏮",
				step_back = "b",
				run_last = "▶▶",
				terminate = "⏹",
				disconnect = "⏏",
			},
		},
	},
	config = function(_, opts)
		local dap = require("dap")
		local dapui = require("dapui")
		dapui.setup(opts)

		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close
	end,
}
