--- @return LazyPluginSpec[]
return {
	--- @type LazyPluginSpec
	{
		"nvimdev/dashboard-nvim",
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
		-- event = "VimEnter",
		lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
		opts = function()
			-- 			local logo = [[
			-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
			-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
			-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
			-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
			-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
			-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
			-- ]]
			-- 			logo = string.rep("\n", 8) .. logo .. "\n\n"
			-- 			header = vim.split(logo, "\n"),
			local opts = {
				theme = "doom",
				hide = {
					-- this is taken care of by lualine
					-- enabling this messes up the actual laststatus setting after loading a file
					statusline = false,
				},
				config = {
					week_header = {
						enable = true,
						-- concat = "concat",
						-- append = { "append" },
					},
					-- header = vim.split(logo, "\n"),
					center = {
						{
							action = "Telescope find_files",
							desc = " Find File",
							icon = vim.g.have_nerd_font and " " or "🔍",
							key = "f",
						},
						{
							action = "ene | startinsert",
							desc = " New File",
							icon = vim.g.have_nerd_font and " " or "📄",
							key = "n",
						},
						{
							action = "Telescope oldfiles",
							desc = " Recent Files",
							icon = vim.g.have_nerd_font and " " or "📑",
							key = "r",
						},
						{
							action = "Telescope live_grep",
							desc = " Find Text",
							icon = vim.g.have_nerd_font and " " or "📋",
							key = "g",
						},
						{
							action = "Telescope find_files cwd=~/.config/nvim",
							desc = " Config",
							icon = vim.g.have_nerd_font and " " or "⚙",
							key = "c",
						},
						{
							action = "LazyGit",
							desc = " Lazy Git",
							icon = vim.g.have_nerd_font and " " or "⌥",
							key = "x",
						},
						{
							action = "Lazy",
							desc = " Lazy",
							icon = vim.g.have_nerd_font and "󰒲 " or "📦",
							key = "l",
						},
						{
							action = function()
								vim.api.nvim_input("<cmd>qa<cr>")
							end,
							desc = " Quit",
							icon = vim.g.have_nerd_font and " " or "⎋",
							key = "q",
						},
						-- { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
					},
					footer = function()
						local stats = require("lazy").stats()
						local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
						return {
							"⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
						}
					end,
				},
			}

			for _, button in ipairs(opts.config.center) do
				button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
				button.key_format = "  %s"
			end

			-- open dashboard after closing lazy
			if vim.o.filetype == "lazy" then
				vim.api.nvim_create_autocmd("WinClosed", {
					pattern = tostring(vim.api.nvim_get_current_win()),
					once = true,
					callback = function()
						vim.schedule(function()
							vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
						end)
					end,
				})
			end

			return opts
		end,
	},
}
