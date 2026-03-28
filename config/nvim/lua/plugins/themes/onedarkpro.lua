---@module "lazy"
---@return LazyPluginSpec
return {
	-- You can easily change to a different colorscheme.
	-- Change the name of the colorscheme plugin below, and then
	-- change the command in the config to whatever the name of that colorscheme is.
	--
	-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
	"olimorris/onedarkpro.nvim",
	enabled = true,
	lazy = false,
	version = false,
	priority = 1000, -- Make sure to load this before all the other start plugins.
	opts = {
		-- Override default colors or create your own
		colors = {},
		-- Override default highlight groups or create your own
		highlights = {},
		-- For example, to apply bold and italic, use "bold,italic"
		styles = {},
		-- Override which filetype highlight groups are loaded
		filetypes = {},
		-- Override which plugin highlight groups are loaded
		plugins = {},
		options = {
			-- Use cursorline highlighting?
			cursorline = true,
			-- Use a transparent background?
			transparency = false,
			-- Use the theme's colors for Neovim's :terminal?
			terminal_colors = true,
			-- Center bar transparency?
			lualine_transparency = false,
			-- When the window is out of focus, change the normal background?
			highlight_inactive_windows = false,
		},
	},
	init = function()
		-- Load the colorscheme here.
		-- Like many other themes, this one has different styles, and you could load
		-- onedark onelight onedark_vivid onedark_dark vaporwave
		vim.cmd.colorscheme("onedark")
	end,
}
