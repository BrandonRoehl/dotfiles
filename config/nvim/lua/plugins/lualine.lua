--- @module 'lazy'
--- @return LazyPluginSpec[]
return {
	--- @return LazyPluginSpec
	{ -- Highlight todo, notes, etc in comments
		"folke/todo-comments.nvim",
		event = "VeryLazy",
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
				-- theme = "tokyonight",
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
