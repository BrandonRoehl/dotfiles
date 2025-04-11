--- @module 'lazy'
--- @return LazyPluginSpec[]
return {
	--- @return LazyPluginSpec
	{
		-- You can easily change to a different colorscheme.
		-- Change the name of the colorscheme plugin below, and then
		-- change the command in the config to whatever the name of that colorscheme is.
		--
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
		"folke/tokyonight.nvim",
		enabled = true,
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
		},
		init = function()
			-- Load the colorscheme here.
			-- Like many other themes, this one has different styles, and you could load
			-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
			vim.cmd.colorscheme("tokyonight")
		end,
	},
	{
		"projekt0n/github-nvim-theme",
		name = "github-theme",
		enabled = false,
		version = "*",
		lazy = false,
		priority = 1000,
		opts = {
			-- ...
		},
		config = function(_, opts)
			require("github-theme").setup(opts)
		end,
		init = function()
			vim.cmd.colorscheme("github_dark_default")
		end,
	},
	{
		-- You can easily change to a different colorscheme.
		-- Change the name of the colorscheme plugin below, and then
		-- change the command in the config to whatever the name of that colorscheme is.
		--
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
		"rebelot/kanagawa.nvim",
		enabled = false,
		version = "*",
		lazy = false,
		priority = 1000, -- Make sure to load this before all the other start plugins.
		--- @module 'kanagawa'
		--- @type KanagawaConfig
		opts = {
			compile = false, -- enable compiling the colorscheme
			undercurl = true, -- enable undercurls
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = true },
			statementStyle = { bold = true },
			typeStyle = {},
			transparent = false, -- do not set background color
			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
			terminalColors = true, -- define vim.g.terminal_color_{0,17}
			colors = { -- add/modify theme and palette colors
				palette = {},
				theme = {
					wave = {},
					lotus = {},
					dragon = {},
					all = {
						ui = {
							bg_gutter = "none",
						},
					},
				},
			},
			overrides = function(colors) -- add/modify highlights
				local theme = colors.theme
				local makeDiagnosticColor = function(color)
					local c = require("kanagawa.lib.color")
					return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
				end

				local opts = {
					-- Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend },
					-- PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
					-- PmenuSbar = { bg = theme.ui.bg_m1 },
					-- PmenuThumb = { bg = theme.ui.bg_p2 },
					-- Diagnostics blend
					DiagnosticVirtualTextHint = makeDiagnosticColor(theme.diag.hint),
					DiagnosticVirtualTextInfo = makeDiagnosticColor(theme.diag.info),
					DiagnosticVirtualTextWarn = makeDiagnosticColor(theme.diag.warning),
					DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),
				}

				if vim.g.border == "none" then
					opts = vim.tbl_extend("force", opts, {
						-- Telescope
						TelescopeTitle = { fg = theme.ui.special, bold = true },
						TelescopePromptNormal = { bg = theme.ui.bg_p1 },
						TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
						TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
						TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
						TelescopePreviewNormal = { bg = theme.ui.bg_dim },
						TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
					})
				end

				return opts
			end,
			theme = "dragon", -- Load "wave" theme
			background = { -- map the value of 'background' option to a theme
				dark = "dragon", -- try "dragon" !
				light = "lotus",
			},
		},
		init = function()
			-- Load the colorscheme here.
			-- Like many other themes, this one has different styles, and you could load
			-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
			vim.cmd.colorscheme("kanagawa")
		end,
	},
	--- @return LazyPluginSpec
	{
		-- You can easily change to a different colorscheme.
		-- Change the name of the colorscheme plugin below, and then
		-- change the command in the config to whatever the name of that colorscheme is.
		--
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
		"catppuccin/nvim",
		enabled = false,
		lazy = false,
		priority = 1000, -- Make sure to load this before all the other start plugins.
		--- @module 'catppuccin'
		--- @type CatppuccinOptions
		opts = {
			flavour = "auto",
			background = {
				light = "latte",
				dark = "mocha",
			},
			default_integrations = true,
			integrations = {
				blink_cmp = true,
				dap = true,
				dap_ui = true,
				dashboard = true,
				gitsigns = true,
				neotree = true,
				treesitter = true,
				treesitter_context = true,
				copilot_vim = true,
				hop = true,
				mason = true,
				fidget = true,
				which_key = true,
				telescope = {
					enabled = true,
					style = vim.g.border == "none" and "nvchad" or "classic",
				},
				semantic_tokens = true,
				-- notify = true,
				-- noice = true,
				-- native_lsp = {
				-- 	enabled = true,
				-- 	virtual_text = {
				-- 		errors = { "italic" },
				-- 		hints = { "italic" },
				-- 		warnings = { "italic" },
				-- 		information = { "italic" },
				-- 		ok = { "italic" },
				-- 	},
				-- 	underlines = {
				-- 		errors = { "underline" },
				-- 		hints = { "underline" },
				-- 		warnings = { "underline" },
				-- 		information = { "underline" },
				-- 		ok = { "underline" },
				-- 	},
				-- 	inlay_hints = {
				-- 		background = true,
				-- 	},
				-- },
				--
			},
			-- custom_highlights = function(colors)
			-- 	return {
			-- 		NormalFloat = { fg = colors.text, bg = colors.mantle }, -- Normal text in floating windows.
			-- 		FloatBorder = { fg = colors.blue, bg = colors.mantle },
			-- 		FloatTitle = { fg = colors.subtext0, bg = colors.mantle }, -- Title of floating windows
			-- 		TelescopeBorder = { fg = colors.blue, bg = colors.none }, -- Border of the telescope window
			-- 	}
			-- end,
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
		end,
		init = function()
			-- Load the colorscheme here.
			-- Like many other themes, this one has different styles, and you could load
			-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
