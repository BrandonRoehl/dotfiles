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
---@class LazyKeysLspSpec: LazyKeysSpec,vim.keymap.set.Opts
---@field method? string|string[] lsp methods that allow this to bind
---@class LazyKeysLsp: LazyKeys
---@field method? string|string[] lsp methods that allow this to bind
---@class LspServerConfig: vim.lsp.Config
---@field keys? LazyKeysLspSpec[]

---@type LazyPluginSpec
return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	import = "plugins.lsp",
	lazy = true,
	event = { "LazyFile" },
	cmd = { "LspInfo", "LspInstall", "LspUninstall" },
	-- `opts_extend` can be a list of dotted keys that will be extended instead of merged
	opts_extend = { "servers.*.keys" },
	---@class LspOptions configs to change when the popup is shown
	opts = {
		---@type table<string, LspServerConfig?>
		servers = {
			["*"] = {
                -- stylua: ignore
                ---@type LazyKeysLspSpec[]
				keys = {
                    -- { "K", vim.lsp.buf.hover, desc = "Hover" },
                    { "gd", vim.lsp.buf.definition, desc = "Goto Definition", method = "textDocument/definition" },
                    { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
                    { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
                    { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
                    { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
                    { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", method = "textDocument/signatureHelp" },
                    { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", method = "textDocument/signatureHelp" },
                    { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", method = "rename" },
                    { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" }, method = "textDocument/codeAction" },
                    { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "x" }, method = "textDocument/codeLens" },
                    { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" }, method = "textDocument/codeLens" },
                    { "<leader>ch>", function()
		            	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		            end, desc = "Toggle Inlay [C]ode [H]ints", method = "textDocument/inlayHint" },
                },
			},
		},
		---@type vim.diagnostic.Opts
		diagnostics = {
			float = {
				border = vim.g.winborder,
				source = "if_many",
				prefix = " ",
				scope = "cursor",
			},
			update_in_insert = false,
			virtual_text = {
				severity = {
					min = vim.diagnostic.severity.ERROR,
				},
			},
			signs = {
				-- linehl = {
				-- 	[vim.diagnostic.severity.ERROR] = "DiagnosticVirtualTextError",
				-- 	[vim.diagnostic.severity.WARN] = "DiagnosticVirtualTextWarn",
				-- 	[vim.diagnostic.severity.HINT] = "DiagnosticVirtualTextHint",
				-- 	[vim.diagnostic.severity.INFO] = "DiagnosticVirtualTextInfo",
				-- },
				text = vim.g.have_nerd_font and {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "",
				} or {},
				numhl = {
					[vim.diagnostic.severity.ERROR] = "DiagnosticError",
					[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
					[vim.diagnostic.severity.HINT] = "DiagnosticHint",
					[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
				},
			},
			underline = true,
			severity_sort = true,
			virtual_lines = false,
			focusable = false,
		},
	},
}
