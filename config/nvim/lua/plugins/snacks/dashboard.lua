---@module "lazy"
---@type LazyPluginSpec
return {
	"folke/snacks.nvim",
	optional = true,
	--- @module 'snacks'
	--- @type snacks.Config
	opts = {
		dashboard = {
			enabled = true,
			preset = {
				keys = {
					{
						icon = vim.g.have_nerd_font and " " or "🔍",
						key = "f",
						desc = "Find File",
						action = ":lua Snacks.dashboard.pick('files')",
					},
					{
						icon = vim.g.have_nerd_font and " " or "📄",
						key = "n",
						desc = "New File",
						action = ":ene | startinsert",
					},
					{
						icon = vim.g.have_nerd_font and " " or "📋",
						key = "g",
						desc = "Find Text",
						action = ":lua Snacks.dashboard.pick('live_grep')",
					},
					{
						icon = vim.g.have_nerd_font and " " or "📑",
						key = "r",
						desc = "Recent Files",
						action = ":lua Snacks.dashboard.pick('oldfiles')",
					},
					{
						icon = vim.g.have_nerd_font and " " or "⚙ ",
						key = "c",
						desc = "Config",
						action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
					},
					{
						icon = vim.g.have_nerd_font and " " or "🔄",
						key = "s",
						desc = "Restore Session",
						section = "session",
					},
					{
						icon = vim.g.have_nerd_font and "󰒲 " or "📦",
						key = "L",
						desc = "Lazy",
						action = ":Lazy",
						enabled = package.loaded.lazy ~= nil,
					},
					{
						icon = vim.g.have_nerd_font and "󱌣 " or "🛠️",
						key = "M",
						desc = "Mason",
						action = ":Mason",
						-- enabled = package.loaded.mason ~= nil,
					},
					{
						icon = vim.g.have_nerd_font and " " or "⎋ ",
						key = "q",
						desc = "Quit",
						action = ":qa",
					},
				},
			},
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				-- { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
				-- { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
				-- { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
				{
					-- pane = 2,
					icon = " ",
					title = "Git Status",
					section = "terminal",
					enabled = function()
						return Snacks.git.get_root() ~= nil
					end,
					cmd = "git status --short --branch --renames",
					height = 5,
					padding = 1,
					ttl = 5 * 60,
					indent = 3,
				},
				{ section = "startup" },
			},
		},
	},
}
