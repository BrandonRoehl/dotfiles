--- @return LazyPluginSpec[]
return {
	--- @return LazyPluginSpec[]
	{
		-- You can easily change to a different colorscheme.
		-- Change the name of the colorscheme plugin below, and then
		-- change the command in the config to whatever the name of that colorscheme is.
		--
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000, -- Make sure to load this before all the other start plugins.
		opts = {
			style = "night", -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
			light_style = "day", -- The theme is used when the background is set to light
			transparent = false, -- Enable this to disable setting the background color
			terminal_colors = false, -- Configure the colors used when opening a `:terminal` in Neovim
		},
		init = function()
			-- Load the colorscheme here.
			-- Like many other themes, this one has different styles, and you could load
			-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
			vim.cmd.colorscheme("tokyonight")

			-- You can configure highlights by doing something like:
			vim.cmd.hi("Comment gui=none")
		end,
	},

	{ -- Highlight todo, notes, etc in comments
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = vim.g.have_nerd_font,
			keywords = {
				FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
				TODO = { icon = " ", color = "info" },
				HACK = { icon = " ", color = "warning" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
				PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				NOTE = { icon = " ", color = "hint", alt = { "INFO", "MARK" } },
				TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
			},
		},
	},
	--- @type LazyPluginSpec
	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.statusline",
		version = "*",
		opts = { use_icons = vim.g.have_nerd_font },
		event = "VimEnter",
		config = function(_, opts)
			-- Simple and easy statusline.
			--  You could remove this setup call if you don't like it,
			--  and try some other statusline plugin
			local statusline = require("mini.statusline")
			-- set use_icons to true if you have a Nerd Font
			statusline.setup(opts)

			-- You can configure sections in the statusline by overriding their
			-- default behavior. For example, here we set the section for
			-- cursor location to LINE:COLUMN
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end

			-- ... and there is more!
			--  Check out: https://github.com/echasnovski/mini.nvim
		end,
	},
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
					-- stylua: ignore
					center = {
						{ action = 'Telescope find_files cwd=',               desc = " Find File",    icon = " ", key = "f" },
						{ action = "ene | startinsert",                       desc = " New File",     icon = " ", key = "n" },
						{ action = 'Telescope oldfiles cwd=',                 desc = " Recent Files", icon = " ", key = "r" },
						{ action = 'Telescope live_grep cwd=',                desc = " Find Text",    icon = " ", key = "g" },
						{ action = 'Telescope find_files cwd=~/.config/nvim', desc = " Config",       icon = " ", key = "c" },
						{ action = "LazyGit",                                 desc = " Lazy Git",     icon = " ", key = "x" },
						{ action = "Lazy",                                    desc = " Lazy",         icon = "󰒲 ", key = "l" },
						{ action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit",  icon = " ", key = "q" },
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
-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
-- require("mini.ai").setup({ n_lines = 500 })

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
-- require("mini.surround").setup()
