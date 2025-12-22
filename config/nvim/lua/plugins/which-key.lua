---@module "lazy"
---@return LazyPluginSpec
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts_extend = { "spec" },
	---@type wk.Opts
	opts = {
		---@type false | "classic" | "modern" | "helix"
		preset = "helix",
		icons = {
			-- set icon mappings to true if you have a Nerd Font
			mappings = vim.g.have_nerd_font,
			-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
			-- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
			keys = vim.g.have_nerd_font and {} or {
				Up = "<Up> ",
				Down = "<Down> ",
				Left = "<Left> ",
				Right = "<Right> ",
				C = "<C-…> ",
				M = "<M-…> ",
				D = "<D-…> ",
				S = "<S-…> ",
				CR = "<CR> ",
				Esc = "<Esc> ",
				ScrollWheelDown = "<ScrollWheelDown> ",
				ScrollWheelUp = "<ScrollWheelUp> ",
				NL = "<NL> ",
				BS = "<BS> ",
				Space = "<Space> ",
				Tab = "<Tab> ",
				F1 = "<F1>",
				F2 = "<F2>",
				F3 = "<F3>",
				F4 = "<F4>",
				F5 = "<F5>",
				F6 = "<F6>",
				F7 = "<F7>",
				F8 = "<F8>",
				F9 = "<F9>",
				F10 = "<F10>",
				F11 = "<F11>",
				F12 = "<F12>",
			},
		},

		--- Document existing key chains
		--- You can add any mappings here, or use `require('which-key').add()` later
		---@type wk.Spec
		spec = {
			{ "<leader>a", group = "[A]I", mode = { "n", "v" } },
			{ "<leader>c", group = "[C]ode", mode = { "n", "x" } },
			{ "<leader>r", group = "[R]ename" },
			{ "<leader>w", group = "[W]orkspace" },
			{ "<leader>t", group = "[T]ab", icon = "󰓩 " },
			{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			{ "g", group = "Goto" },
			{ "K", desc = "LSP Hover", mode = { "n" } },
			{ "<BS>", desc = "Decrement Selection", mode = "x" },
			{ "<c-space>", desc = "Increment Selection", mode = { "x", "n" } },
		},

		win = {
			title = true,
			border = vim.g.winborder,
		},
	},
	-- Show the local buffer mappings
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = true })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
