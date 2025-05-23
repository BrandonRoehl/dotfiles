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
	event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
	cmd = { "LspInfo", "LspInstall", "LspUninstall" },
	dependencies = {
		-- Useful status updates for LSP.
		"j-hui/fidget.nvim",

		-- Automatically install LSPs and related tools to stdpath for Neovim
		{ "mason-org/mason-lspconfig.nvim", dependencies = "mason-org/mason.nvim" },

		-- Allows extra capabilities provided by blink
		"saghen/blink.cmp",
	},
	opts = {
		---@type string[]
		-- Enable the following language servers
		-- Feel free to add/remove any LSPs that you want here. They will automatically be installed.
		servers = {},
		---@type string[]
		-- Servers to skip installing with mason
		ensure_installed = {},
	},
	-- `opts_extend` can be a list of dotted keys that will be extended instead of merged
	opts_extend = { "servers", "ensure_installed" },
	config = function(_, opts)
		-- if nerd_font override the signs column
		local signs = vim.tbl_get(opts, "diagnostics", "signs")
		if vim.g.have_nerd_font and signs then
			for key, sign in pairs({
				[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
				[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
				[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
				[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
			}) do
				vim.fn.sign_define(sign, {
					text = vim.tbl_get(signs, "text", key),
					texthl = vim.tbl_get(signs, "numl", key),
				})
			end
		end

		if vim.g.border then
			-- To override globally the opts if none are provided
			-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#borders
			local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or vim.g.border
				return orig_util_open_floating_preview(contents, syntax, opts, ...)
			end
		end

		vim.diagnostic.config(opts.diagnostics)

		--  This function gets run when an LSP attaches to a particular buffer.
		--    That is to say, every time a new file is opened that is associated with
		--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
		--    function will be executed to configure the current buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lazy-lsp-attach", { clear = true }),
			callback = opts.on_attach,
		})

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

		-- LSP servers and clients are able to communicate to each other what features they support.
		-- By default, Neovim doesn't support everything that is in the LSP specification.
		-- When you add blink-cmp, luasnip, etc. Neovim now has *more* capabilities.
		-- So, we create new capabilities with blink cmp, and then broadcast that to the servers.
		vim.lsp.config("*", {
			--- @type lsp.ClientCapabilities
			capabilities = vim.tbl_extend(
				"force",
				vim.lsp.protocol.make_client_capabilities(),
				require("blink.cmp").get_lsp_capabilities()
			),
		})
		vim.lsp.enable(opts.servers)
	end,
}
