-- DAP Plugins
---@module "lazy"
---@return LazyPluginSpec[]
return {
	--- @type LazyPluginSpec
	{
		"mfussenegger/nvim-dap",
		version = false,
		desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			-- virtual text for the debugger
			{
				"theHamsta/nvim-dap-virtual-text",
				version = false,
				opts = {},
			},
			{
				"jay-babu/mason-nvim-dap.nvim",
				version = false,
				dependencies = "mason.nvim",
				cmd = { "DapInstall", "DapUninstall" },
				-- mason-nvim-dap is loaded when nvim-dap loads
				config = true,
			},
			-- Golang
			{ "leoluz/nvim-dap-go", config = true, version = false },
		},
		-- stylua: ignore
		keys = {
			{ "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
			{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
			{ "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
			-- { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
			{ "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
			{ "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
			{ "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
			{ "<leader>dj", function() require("dap").down() end, desc = "Down" },
			{ "<leader>dk", function() require("dap").up() end, desc = "Up" },
			{ "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
			{ "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
			{ "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
			{ "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
			{ "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
			{ "<leader>ds", function() require("dap").session() end, desc = "Session" },
			{ "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
			{ "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
			-- Python ones
		},
		config = function()
			-- load mason-nvim-dap here, after all adapters have been setup
			-- if LazyVim.has("mason-nvim-dap.nvim") then
			-- 	require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
			-- end
			require("dap")

			require("mason-nvim-dap").setup({
				-- Makes a best effort to setup the various debuggers with
				-- reasonable debug configurations
				automatic_installation = true,

				-- You can provide additional configuration to the handlers,
				-- see mason-nvim-dap README for more information
				handlers = {},

				-- You'll need to check that you have the required things installed
				-- online, please don't ask me how to install them :)
				ensure_installed = {
					-- Update this to ensure that you have the debuggers for the langs you want
					"delve",
				},
			})

			-- Set some icons
			vim.api.nvim_set_hl(0, "DapBreak", { fg = "#e51400" })
			vim.api.nvim_set_hl(0, "DapStop", { fg = "#ffcc00" })
			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
			-- stylua: ignore
			local breakpoint_icons = vim.g.have_nerd_font and {
				Breakpoint = "",
				BreakpointCondition = "",
				BreakpointRejected = "",
				LogPoint = "",
				Stopped = "",
			} or {
				Breakpoint = "●",
				BreakpointCondition = "⊜",
				BreakpointRejected = "⊘",
				LogPoint = "◆",
				Stopped = "⭔",
			}
			for type, icon in pairs(breakpoint_icons) do
				local tp = "Dap" .. type
				local hl = (type == "Stopped") and "DapStop" or "DapBreak"
				vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
			end

			-- setup dap config by VSCode launch.json file
			local vscode = require("dap.ext.vscode")
			local json = require("plenary.json")
			vscode.json_decode = function(str)
				return vim.json.decode(json.json_strip_comments(str))
			end

			-- Install golang specific config
			require("dap-go").setup({
				delve = {
					-- On Windows delve must be run attached or it crashes.
					-- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
					detached = vim.fn.has("win32") == 0,
				},
			})
		end,
	},
	{
		"mfussenegger/nvim-dap",
		enabled = Utils:is_computer("🔥"),
		dependencies = {
			-- Python
			{ "mfussenegger/nvim-dap-python", version = false },
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
	},
	-- @type LazyPluginSpec
	{
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
	},
}
