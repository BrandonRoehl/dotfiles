---@module "lazy"
---@type LazyPluginSpec[]
return {
	-- Ensure the servers and tools above are installed
	--  To check the current status of installed tools and/or manually install
	--  other tools, you can run
	--    :Mason
	--
	--  You can press `g?` for help in this menu.
	-- require("mason").setup()
	--- @type LazyPluginSpec
	{
		"mason-org/mason.nvim",
		lazy = true,
		cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts_extend = { "ensure_installed" },
		--- @module 'mason'
		--- @type MasonSettings | {ensure_installed: string[]}
		opts = {
			ui = {
				border = vim.g.border,
			},
		},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)

			mr.refresh(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
		end,
	},
	{
		"neovim/nvim-lspconfig",
		optional = true,
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			{ "mason-org/mason-lspconfig.nvim", dependencies = "mason-org/mason.nvim" },
		},
		opts_extend = { "ensure_installed", "setup_extend" },
		opts = {
			---@type string[]
			-- Servers to skip installing with mason
			ensure_installed = {},
			---@type fun(self:LazyPlugin, opts:table)[]
			-- Will be executed when loading the plugin
			setup_extend = {
				function(_, opts)
					-- Mark what needs to be installed with Mason
					-- local ensure_installed = vim.tbl_filter(function(server)
					-- 	return not vim.tbl_contains(opts.exclude, server)
					-- end, opts.servers)
					require("mason-lspconfig").setup(
						---@type MasonLspconfigSettings
						{
							ensure_installed = opts.ensure_installed,
							automatic_enable = false,
						}
					)
				end,
			},
		},
	},
}
