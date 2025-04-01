--- @module 'lazy'
--- @return LazyPluginSpec[]
return {
	--- @return LazyPluginSpec[]
	{
		-- You can easily change to a different colorscheme.
		-- Change the name of the colorscheme plugin below, and then
		-- change the command in the config to whatever the name of that colorscheme is.
		--
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
		"Mofiqul/vscode.nvim",
		dependencies = {
			"nvim-neo-tree/neo-tree.nvim",
		},
		version = "*",
		lazy = false,
		priority = 1000, -- Make sure to load this before all the other start plugins.
		opts = {
			transparent = false,
			italic_comments = false,
			underline_links = false,
			color_overrides = {},
			group_overrides = {},
			disable_nvimtree_bg = false,
			terminal_colors = true,
		},
		config = function(_, opts)
			local n = require("neo-tree.ui.highlights")
			local c = require("vscode.colors").get_colors()

			opts.group_overrides = {
				-- this supports the same val table as vim.api.nvim_set_hl
				-- use colors from this colorscheme by requiring vscode.colors!
				Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
				-- NeoTreeDirectoryIcon = { fg = c.vscYellowOrange },
				-- [n.DIRECTORY_NAME] = { fg = c.vscBack },

				-- neo-tree color config
				[n.DIRECTORY_ICON] = { fg = c.vscYellowOrange },
				[n.DIM_TEXT] = { fg = c.vscDimHighlight },
				[n.HIDDEN_BY_NAME] = { fg = c.vscDimHighlight },

				[n.GIT_ADDED] = { fg = c.vscGitAdded },
				[n.GIT_CONFLICT] = { fg = c.vscGitConflicting },
				[n.GIT_DELETED] = { fg = c.vscGitDeleted },
				[n.GIT_IGNORED] = { fg = c.vscGitIgnored },
				[n.GIT_MODIFIED] = { fg = c.vscGitModified },
				[n.GIT_RENAMED] = { fg = c.vscGitRenamed },
				[n.GIT_STAGED] = { fg = c.vscGitStageModified },
				[n.GIT_UNSTAGED] = { fg = c.vscGitStageDeleted },
				[n.GIT_UNTRACKED] = { fg = c.vscGitUntracked },
				[n.GIT_IGNORED] = { fg = c.vscDimHighlight },
			}
			require("vscode").setup(opts)
		end,
		init = function()
			-- Load the colorscheme here.
			-- Like many other themes, this one has different styles, and you could load
			-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
			vim.cmd.colorscheme("vscode")

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
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		version = "*",
		opts = {
			options = {
				icons_enabled = vim.g.have_nerd_font,
				theme = "vscode",
				globalstatus = vim.o.laststatus == 3,
				component_separators = { left = "│", right = "│" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" },
					winbar = {},
				},
			},
			sections = {
				-- Add CodeCompanion to the right side of the status line
				lualine_x = {
					-- This will be replaced by the actual component in the config function
					-- this is registered in `lua/lualine/components`
					"codecompanion",
					"encoding",
					"fileformat",
					"filetype",
				},
			},
			extensions = { "lazy", "mason", "neo-tree", "nvim-dap-ui" },
		},
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
