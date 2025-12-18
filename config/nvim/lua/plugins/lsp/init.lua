-- Brief aside: **What is LSP?**
--
-- LSP is an initialism you've probably heard, but might not understand what it is.
--
-- LSP stands for Language Server Protocol. It's a protocol that helps editors
-- and language tooling communicate in a standardized fashion.
--
-- In general, you have a "server" which is some tool built to understand a particular
-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
-- processes that communicate with some "client" - in this case, Neovim!
--
-- LSP provides Neovim with features like:
--  - Go to definition
--  - Find references
--  - Autocompletion
--  - Symbol Search
--  - and more!
--
-- Thus, Language Servers are external tools that must be installed separately from
-- Neovim. This is where `mason` and related plugins come into play.
--
-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
-- and elegantly composed help section, `:help lsp-vs-treesitter`

---@class LspServerConfig: vim.lsp.Config
---@field keys? LazyKeysSpec[]|fun(self:LazyPlugin, keys:string[]):LazyKeys[]

---@module "lazy"
---@type LazyPluginSpec
return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	import = "plugins.lsp",
	lazy = true,
	event = { "BufReadPost", "BufNewFile", "VeryLazy" },
	cmd = { "LspInfo", "LspInstall", "LspUninstall" },
	-- `opts_extend` can be a list of dotted keys that will be extended instead of merged
	opts_extend = { "servers.*.keys" },
	---@class LspOptions configs to change when the popup is shown
	opts = {
		---@type fun(self:LazyPlugin, opts:table)[]
		-- Will be executed when loading the plugin
		setup_extend = {},
		---@type table<string, LspServerConfig?>
		servers = {
			["*"] = {
				keys = {},
			},
		},
	},
	---@param plugin LazyPlugin
	---@param opts LspOptions
	config = function(plugin, opts)
		--https://neovim.io/doc/user/lsp.html#lsp-config-merge
		-- The configuration that is used will be merging keeping keys
		-- 1. `nvim/lsp/name.lua`
		--   - provided by "nvim-lspconfig"
		-- 2. `nvim/lsp/after/name.lua`
		--   - custom overrides for your config
		-- 3. `{ opts.servers.name }`
		--   - extra features provided by plugins

		-- First apply any custom configuration provided by plugins
		for server, config in pairs(opts.servers or {}) do
			vim.lsp.config(server, config)
		end
		-- Trigger pre enable after servers are configured
		vim.api.nvim_exec_autocmds("User", {
			pattern = "LspPreEnable",
			data = opts,
		})
		for _, func in ipairs(opts.setup_extend or {}) do
			func(plugin, opts)
		end
		-- Enable all servers that have provided keys
		local enable = vim.tbl_filter(function(server)
			return server ~= "*"
		end, vim.tbl_keys(opts.servers or {}))
		if #enable > 0 then
			vim.lsp.enable(enable)
		end
		vim.api.nvim_exec_autocmds("User", {
			pattern = "LspPostEnable",
			data = opts,
		})
	end,
}
