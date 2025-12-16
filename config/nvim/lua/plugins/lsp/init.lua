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

---@module "lazy"
---@type LazyPluginSpec
return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	import = "plugins.lsp",
	lazy = true,
	event = { "BufReadPost", "BufNewFile", "VeryLazy" },
	cmd = { "LspInfo", "LspInstall", "LspUninstall" },
	opts = {
		---@type string[]
		-- Enable the following language servers
		-- Feel free to add/remove any LSPs that you want here. They will automatically be installed.
		servers = {},
		---@type fun(self:LazyPlugin, opts:table)[]
		-- Will be executed when loading the plugin
		extend_config = {},
	},
	-- `opts_extend` can be a list of dotted keys that will be extended instead of merged
	opts_extend = { "servers", "ensure_installed" },
	config = function(plugin, opts)
		for _, func in ipairs(opts.extend_config or {}) do
			func(plugin, opts)
		end

		vim.lsp.enable(opts.servers)
	end,
}
