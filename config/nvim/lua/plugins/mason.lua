-- Mason
--- @module 'lazy'
--- @return LazyPluginSpec[]
return {
	-- Ensure the servers and tools above are installed
	--  To check the current status of installed tools and/or manually install
	--  other tools, you can run
	--    :Mason
	--
	--  You can press `g?` for help in this menu.
	-- require("mason").setup()
	--- @type LazyPluginSpec
	{ -- Mason general setup
		"williamboman/mason.nvim",
		version = "*",
		config = true,
		lazy = true,
		cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
		--- @module 'mason'
		--- @class MasonSettings
		opts = {
			ui = {
				border = vim.g.border,
				-- icons = {},
			},
		},
	},
}
