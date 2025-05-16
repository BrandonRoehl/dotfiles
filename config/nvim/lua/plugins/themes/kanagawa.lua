---@module "lazy"
---@return LazyPluginSpec
return {
	"rebelot/kanagawa.nvim",
	enabled = true,
	lazy = false,
	version = false,
	priority = 1000, -- Make sure to load this before all the other start plugins.
	---@module 'kanagawa'
	---@type KanagawaConfig
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

			return opts
		end,
		-- theme = "wave", -- Load "wave" theme
		background = { -- map the value of 'background' option to a theme
			dark = "dragon", -- try "dragon" !
			light = "lotus",
		},
	},
	init = function()
		vim.cmd.colorscheme("kanagawa")
	end,
}
