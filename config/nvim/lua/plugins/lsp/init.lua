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

---@class LazyKeysLspSpec: LazyKeysSpec,snacks.keymap.set.Opts
---@class LazyKeysLsp: LazyKeys,snacks.keymap.set.Opts

---@class LspServerConfig: vim.lsp.Config
---@field keys? LazyKeysLspSpec[]

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
		servers = {},
		---@type vim.diagnostic.Opts
		diagnostics = {},
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
			-- data = opts,
		})
		for _, func in ipairs(opts.setup_extend or {}) do
			func(plugin, opts)
		end

		-- Still bugs around `vim.o.winborder`
		-- waiting on mason and snacks to remove this
		if vim.g.winborder then
			-- To override globally the opts if none are provided
			-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#borders
			local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or vim.g.winborder
				return orig_util_open_floating_preview(contents, syntax, opts, ...)
			end
		end

		-- Configure diagnostics
		vim.diagnostic.config(opts.diagnostics)
		-- Enable all servers that have provided keys
		local enable = vim.tbl_filter(function(server)
			return server ~= "*"
		end, vim.tbl_keys(opts.servers or {}))
		if #enable > 0 then
			vim.lsp.enable(enable)
		end
		vim.api.nvim_exec_autocmds("User", {
			pattern = "LspPostEnable",
			-- data = opts,
		})
	end,
}
