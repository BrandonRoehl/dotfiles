---@module "lazy"
---@return LazyPluginSpec
return {
	-- You can easily change to a different colorscheme.
	-- Change the name of the colorscheme plugin below, and then
	-- change the command in the config to whatever the name of that colorscheme is.
	--
	-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
	"folke/tokyonight.nvim",
	enabled = true,
	lazy = false,
	version = false,
	priority = 1000, -- Make sure to load this before all the other start plugins.
	---@module 'tokyonight'
	---@type tokyonight.Config
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
		},
	},
	init = function()
		-- Load the colorscheme here.
		-- Like many other themes, this one has different styles, and you could load
		-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
		vim.cmd.colorscheme("tokyonight")
	end,
}
