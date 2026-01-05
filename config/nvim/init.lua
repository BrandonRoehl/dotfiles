-- https://lazy.folke.io/installation
-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Load custom helpers
require("utils")
-- Register custom events before setup
Utils.lazy.lazy_file()
Utils.lazy.register_custom_event("LazyDap", "LspPreEnable", "LspPostEnable")

-- [[ Configure Neovim ]]
--
-- This is the base like your leader globals and stuff not requiring plugins
require("config")

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	defaults = {
		-- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
		-- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
		lazy = false,
		-- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
		-- have outdated releases, which may break your Neovim install.
		-- version = false, -- always use the latest git commit
		version = "*", -- try installing the latest stable version for plugins that support semver
	},
	dev = {
		-- Directory where you store your local plugin projects. If a function is used,
		-- the plugin directory (e.g. `~/projects/plugin-name`) must be returned.
		---@type string | fun(plugin: LazyPlugin): string
		path = "~/workspace/",
		---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
		patterns = { "BrandonRoehl" },
		-- Fallback to git when local plugin doesn't exist
		fallback = true,
	},
	install = {
		-- install missing plugins on startup. This doesn't increase startup time.
		missing = true,
		-- try to load one of these colorschemes when starting an installation during startup
		colorscheme = { "tokyonight", "catppuccin", "kanagawa", "default" },
	},
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = false,
		notify = true, -- get a notification when changes are found
	},
	checker = {
		-- automatically check for plugin updates
		enabled = true, -- check for plugin updates periodically
		notify = false, -- notify on update
	},
	ui = {
		border = vim.g.winborder,
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
