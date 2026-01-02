---@module "lazy"
---@type LazyPluginSpec
return {
	"mfussenegger/nvim-dap",
	version = false,
	lazy = true,
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
			dependencies = "mason-org/mason.nvim",
			cmd = { "DapInstall", "DapUninstall" },
			-- mason-nvim-dap is loaded when nvim-dap loads
			config = false,
		},
	},
	specs = {
		"folke/which-key.nvim",
		optional = true,
		opts = {
			---@type wk.Spec
			spec = {
				{ "<leader>d", group = "[D]ebug", icon = " " },
			},
		},
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

		-- The custom event exec that causes the other setup plugins to run
		Utils.lazy.trigger_custom_event("LazyDap")
	end,
}
