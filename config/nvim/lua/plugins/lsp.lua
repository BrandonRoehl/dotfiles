-- LSP Plugins
---@module "lazy"
---@type LazyPluginSpec
return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	lazy = true,
	event = { "BufRead", "BufNewFile", "VeryLazy" },
	cmd = { "LspInfo", "LspInstall", "LspUninstall" },
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		{ "mason-org/mason-lspconfig.nvim", dependencies = "mason-org/mason.nvim" },
		-- Useful status updates for LSP.
		"j-hui/fidget.nvim",

		-- UI for actions
		"folke/snacks.nvim",

		-- Allows extra capabilities provided by blink
		"saghen/blink.cmp",
	},
	opts = {
		---@type string[]
		-- Enable the following language servers
		-- Feel free to add/remove any LSPs that you want here. They will automatically be installed.
		servers = {
			-- "pyright",
			"basedpyright",
			"ruff",
			"rust_analyzer",
			"gopls",
			"sourcekit",
			"clangd",
			"ts_ls",
			"volar",
			"lua_ls",
			-- "vale_ls",
			"harper_ls",
			"gdscript",
			"graphql",
			"texlab",
		},
		---@type string[]
		-- Servers to skip installing with mason
		exclude = Utils:is_win() and {
			"clangd",
			"solargraph",
			"sourcekit",
			"rust_analyzer",
			"gdscript",
			"gopls",
		} or {
			"clangd",
			"solargraph",
			"sourcekit",
			"gdscript",
		},
	},
	config = function(_, opts)
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

		--  This function gets run when an LSP attaches to a particular buffer.
		--    That is to say, every time a new file is opened that is associated with
		--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
		--    function will be executed to configure the current buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				-- NOTE: Remember that Lua is a real programming language, and as such it is possible
				-- to define small helper and utility functions so you don't have to repeat yourself.
				--
				-- In this case, we create a function that lets us more easily define mappings specific
				-- for LSP related items. It sets the mode, buffer and description for us each time.
				---@param keys string Left-hand side |{lhs}| of the mapping.
				---@param func string|function Right-hand side |{rhs}| of the mapping, can be a Lua function.
				---@param opts? vim.keymap.set.Opts
				---@param mode? string|string[] Mode "short-name" (see |nvim_set_keymap()|), or a list thereof.
				local function map(keys, func, opts, mode)
					mode = mode or "n"
					opts.buffer = event.buf
					vim.keymap.set(mode, keys, func, opts)
				end

				-- Jump to the definition of the word under your cursor.
				--  This is where a variable was first declared, or where a function is defined, etc.
				--  To jump back, press <C-t>.

				-- lsp keybinds
				map("gd", Snacks.picker.lsp_definitions, { desc = "[G]oto [D]efinition" })
				map("gD", Snacks.picker.lsp_declarations, { desc = "[G]oto [D]eclaration" })
				map("gr", Snacks.picker.lsp_references, { nowait = true, desc = "[R]eferences" })
				map("gI", Snacks.picker.lsp_implementations, { desc = "Goto [I]mplementation" })
				map("gy", Snacks.picker.lsp_type_definitions, { desc = "Goto T[y]pe Definition" })
				map("<leader>ss", Snacks.picker.lsp_symbols, { desc = "LSP [S]ymbols" })
				map("<leader>sS", Snacks.picker.lsp_workspace_symbols, { desc = "LSP Workspace [S]ymbols" })
				-- map("gd", vim.lsp.buf.definition, { desc = "[G]oto [D]efinition" })
				-- map("gD", vim.lsp.buf.declaration, { desc = "[G]oto [D]eclaration" })
				-- map("gr", vim.lsp.buf.references, { nowait = true, desc = "[R]eferences" })

				-- Rename the variable under your cursor.
				--  Most Language Servers support renaming across files, etc.
				map("<leader>rn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })

				-- Execute a code action, usually your cursor needs to be on top an error
				-- or a suggestion from your LSP for this to activate.
				map("<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" }, { "n", "x" })

				-- The following autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--    See `:help CursorHold` for information about when this is executed
				--
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if
					client
					and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
				then
					-- vim.cmd([[
					-- hi! LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
					-- hi! LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
					-- hi! LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
					-- ]])
					vim.api.nvim_create_augroup("lsp_document_highlight", {
						clear = false,
					})
					vim.api.nvim_clear_autocmds({
						buffer = event.buf,
						group = "lsp_document_highlight",
					})
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						group = "lsp_document_highlight",
						buffer = event.buf,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						group = "lsp_document_highlight",
						buffer = event.buf,
						callback = vim.lsp.buf.clear_references,
					})
				end

				-- The following auto commands trigger the diagnostics for what you are hovering
				vim.api.nvim_create_autocmd("CursorHold", {
					buffer = event.buf,
					callback = function()
						-- Check if there are any visible floating windows already
						-- for _, win in ipairs(vim.api.nvim_list_wins()) do
						-- 	if vim.api.nvim_win_get_config(win).relative ~= "" then
						-- 		-- A float exists, don't create another one
						-- 		return
						-- 	end
						-- end

						vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
					end,
				})

				-- The following code creates a keymap to toggle inlay hints in your
				-- code, if the language server you are using supports them
				--
				-- This may be unwanted, since they displace some of your code
				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
					map("<leader>ch", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, { desc = "Toggle Inlay [C]ode [H]ints" })
				end
			end,
		})

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

		--- @type vim.diagnostic.Opts
		local diag_opts = {
			float = {
				border = vim.g.border,
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
		}
		if vim.g.have_nerd_font then
			vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticError" })
			vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticWarn" })
			vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticInfo" })
			vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticHint" })
			diag_opts.signs.text = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN] = "",
				[vim.diagnostic.severity.INFO] = "",
				[vim.diagnostic.severity.HINT] = "",
			}
		end
		vim.diagnostic.config(diag_opts)

		-- Mark what needs to be installed with Mason
		local ensure_installed = vim.tbl_filter(function(server)
			return not vim.tbl_contains(opts.exclude, server)
		end, opts.servers)
		require("mason-lspconfig").setup(
			---@type MasonLspconfigSettings
			{
				ensure_installed = ensure_installed,
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
