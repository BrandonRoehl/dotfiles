-- Ensure the servers and tools above are installed
--  To check the current status of installed tools and/or manually install
--  other tools, you can run
--    :Mason
--
--  You can press `g?` for help in this menu.
-- require("mason").setup()
--- @type LazyPluginSpec
return {
	"mason-org/mason.nvim",
	lazy = true,
	cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
	keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
	build = ":MasonUpdate",
	opts_extend = { "ensure_installed" },
	---@module 'mason'
	---@type MasonSettings | {ensure_installed: string[]}
	opts = {
		ui = {
			border = vim.g.winborder,
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
	specs = {
		"mason-org/mason-lspconfig.nvim",
		dependencies = "mason-org/mason.nvim",
		lazy = true,
		event = { "LspPreEnable" },
		config = true,
		opts_extend = { "ensure_installed" },
		---@module 'mason-lspconfig'
		---@type MasonLspconfigSettings settings for what to install
		opts = {
			ensure_installed = {},
			automatic_enable = false,
		},
	},
}
