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
		"folke/tokyonight.nvim",
		version = "*",
		lazy = false,
		priority = 1000, -- Make sure to load this before all the other start plugins.
		--- @module 'tokyonight'
		--- @type tokyonight.Config
		opts = {
			style = "night", -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
			light_style = "day", -- The theme is used when the background is set to light
			transparent = false, -- Enable this to disable setting the background color
			terminal_colors = false, -- Configure the colors used when opening a `:terminal` in Neovim
			lualine_bold = true,
			cache = true,
			plugins = {
				-- enable all plugins when not using lazy.nvim
				-- set to false to manually enable/disable plugins
				all = package.loaded.lazy == nil,
				-- uses your plugin manager to automatically enable needed plugins
				-- currently only lazy.nvim is supported
				auto = true,
				-- add any plugins here that you want to enable
				-- for all possible plugins, see:
				--   * https://github.com/folke/tokyonight.nvim/tree/main/lua/tokyonight/groups
				telescope = true,
			},
			-- if you want borderless popups
			-- on_highlights = function(hl, c)
			-- 	-- local prompt = "#2d3149"
			-- 	local prompt = c.bg_highlight
			-- 	local results = c.bg_float
			-- 	local preview = "#1d212f"
			-- 	hl.TelescopeNormal = {
			-- 		fg = c.fg,
			-- 		bg = preview,
			-- 	}
			-- 	hl.TelescopeBorder = {
			-- 		bg = preview,
			-- 		fg = preview,
			-- 	}
			-- 	hl.TelescopePromptNormal = {
			-- 		bg = prompt,
			-- 	}
			-- 	hl.TelescopePromptBorder = {
			-- 		bg = prompt,
			-- 		fg = prompt,
			-- 	}
			-- 	hl.TelescopePromptTitle = {
			-- 		bg = prompt,
			-- 		fg = c.orange,
			-- 	}
			-- 	hl.TelescopePreviewTitle = {
			-- 		bg = c.green,
			-- 		fg = c.bg_float,
			-- 	}
			-- 	hl.TelescopeResultsTitle = {
			-- 		bg = c.cyan,
			-- 		fg = c.bg_float,
			-- 	}
			-- 	hl.TelescopeResultsBorder = {
			-- 		bg = results,
			-- 		fg = results,
			-- 	}
			-- 	hl.TelescopeResultsNormal = {
			-- 		bg = results,
			-- 		fg = c.fg,
			-- 	}
			-- 	-- Which key
			-- 	hl.WhichKeyBorder = {
			-- 		bg = c.bg_float,
			-- 		fg = c.bg_float,
			-- 	}
			-- end,
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
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		version = "*",
		opts = {
			options = {
				icons_enabled = vim.g.have_nerd_font,
				theme = "tokyonight",
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
					{
						-- This will be replaced by the actual component in the config function
						-- this is registered in `lua/lualine/components`
						"codecompanion",
					},
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
