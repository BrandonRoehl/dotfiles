---@module "lazy"
---@return LazyPluginSpec
return {
	"catppuccin/nvim",
	enabled = true,
	lazy = false,
	version = false,
	priority = 1000,
	---@module 'catppuccin'
	---@type CatppuccinOptions
	opts = {
		flavour = "auto",
		background = {
			light = "latte",
			dark = "mocha",
		},
		auto_integrations = true,
		-- custom_highlights = function(colors)
		-- 	return {
		-- 		NormalFloat = { fg = colors.text, bg = colors.mantle }, -- Normal text in floating windows.
		-- 		FloatBorder = { fg = colors.blue, bg = colors.mantle },
		-- 		FloatTitle = { fg = colors.subtext0, bg = colors.mantle }, -- Title of floating windows
		-- 		TelescopeBorder = { fg = colors.blue, bg = colors.none }, -- Border of the telescope window
		-- 	}
		-- end,
		-- custom_highlights = function(colors)
		-- 	return {
		-- 		SnacksIndent1 = { fg = colors.red },
		-- 		SnacksIndent2 = { fg = colors.yellow },
		-- 		SnacksIndent3 = { fg = colors.blue },
		-- 		SnacksIndent4 = { fg = colors.peach },
		-- 		SnacksIndent5 = { fg = colors.green },
		-- 		SnacksIndent6 = { fg = colors.mauve },
		-- 		SnacksIndent7 = { fg = colors.teal },
		-- 		SnacksIndent8 = { fg = colors.lavender },
		-- 	}
		-- end,
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
	end,
	init = function()
		vim.cmd.colorscheme("catppuccin-nvim")
	end,
}
