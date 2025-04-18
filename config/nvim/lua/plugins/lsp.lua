-- LSP Plugins
--- @module 'lazy'
--- @return LazyPluginSpec[]
return {
	--- @type LazyPluginSpec
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		version = "*",
		lazy = true,
		-- event = "BufWinEnter",
		event = { "BufWinEnter", "BufReadPost", "BufNewFile" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall" },
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			"williamboman/mason.nvim", -- NOTE: Must be added on the top level
			"williamboman/mason-lspconfig.nvim",

			-- Useful status updates for LSP.
			"j-hui/fidget.nvim",

			-- Allows extra capabilities provided by blink
			"saghen/blink.cmp",
		},
		config = function()
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
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						local rhs = type(func) == "function"
								and function()
									require("telescope")
									func()
								end
							or func
						vim.keymap.set(mode, keys, rhs, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-t>.

					map("gd", "<cmd>Telescope lsp_definitions<cr>", "[G]oto [D]efinition")

					-- Find references for the word under your cursor.
					map("gr", "<cmd>Telescope lsp_references<cr>", "[G]oto [R]eferences")

					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					map("gI", "<cmd>Telescope lsp_implementations<cr>", "[G]oto [I]mplementation")

					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					map("<leader>cD", "<cmd>Telescope lsp_type_definitions<cr>", "Type [D]efinition")

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					map("<leader>cs", "<cmd>Telescope lsp_document_symbols<cr>", "[C]ode [S]ymbols")

					-- Fuzzy find all the symbols in your current workspace.
					--  Similar to document symbols, except searches over your entire project.
					map("<leader>ws", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "[W]orkspace [S]ymbols")

					-- Rename the variable under your cursor.
					--  Most Language Servers support renaming across files, etc.
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action, usually your cursor needs to be on top an error
					-- or a suggestion from your LSP for this to activate.
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

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
							for _, win in ipairs(vim.api.nvim_list_wins()) do
								if vim.api.nvim_win_get_config(win).relative ~= "" then
									-- A float exists, don't create another one
									return
								end
							end

							vim.diagnostic.open_float(nil)
						end,
					})

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if
						client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>ch", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "Toggle Inlay [C]ode [H]ints")
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
					[vim.diagnostic.severity.HINT] = "󰌵",
				}
			end
			vim.diagnostic.config(diag_opts)

			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
			--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
			--- @type lsp.ClientCapabilities
			-- local capabilities = vim.lsp.protocol.make_client_capabilities()
			local capabilities = require("blink.cmp").get_lsp_capabilities({}, true)

			-- Enable the following language servers
			--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
			--
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				-- pyright = {
				-- 	-- https://github.com/microsoft/pyright/blob/main/docs/settings.md
				-- 	settings = {
				-- 		single_file_support = true,
				-- 		python = {
				-- 			analysis = {
				-- 				autoSearchPaths = true,
				-- 				diagnosticMode = "openFilesOnly",
				-- 				useLibraryCodeForTypes = true,
				-- 				typeCheckingMode = "basic",
				-- 			},
				-- 		},
				-- 	},
				-- 	-- 	single_file_support = true,
				-- }, -- python
				basedpyright = {
					-- docs/configuration/language-server-settings.md
					settings = {
						basedpyright = {
							typeCheckingMode = "basic",
						},
					},
				}, -- better python
				ruff = {}, -- python formatting that works with basedpyright
				rust_analyzer = {}, -- rust
				gopls = {
					settings = {
						-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
						gopls = {
							gofumpt = true,
							-- https://github.com/golang/tools/blob/master/gopls/doc/codelenses.md
							codelenses = {
								gc_details = false,
								generate = true,
								regenerate_cgo = true,
								-- run_govulncheck = true,
								test = true,
								tidy = true,
								upgrade_dependency = true,
								vendor = true,
							},
							-- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							-- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
							-- analyses = {},
							usePlaceholders = true,
							-- staticcheck = true,
							directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
							semanticTokens = true,
						},
					},
				}, -- golang
				sourcekit = {}, -- swift
				clangd = {}, -- c and c++ after sourcekit so sourcekit is used if available
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				--
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				--
				-- But for many setups, the LSP (`ts_ls`) will work just fine
				ts_ls = {
					--- @type lsp.ClientCapabilities
					capabilities = {
						textDocument = {
							formatting = nil,
						},
					},
					init_options = {
						plugins = { -- I think this was my breakthrough that made it work
							{
								name = "@vue/typescript-plugin",
								location = "/usr/local/lib/node_modules/@vue/language-server",
								languages = { "vue" },
							},
						},
					},
					on_new_config = function(new_config, new_root_dir)
						local lib_path =
							vim.fs.find("node_modules/@vue/language-server", { path = new_root_dir, upward = true })[1]
						if lib_path then
							new_config.init_options.plugins[0].location = lib_path
						end
					end,
					filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
				},
				volar = {
					-- add filetypes for typescript, javascript and vue
					filetypes = { "vue" },
					init_options = {
						vue = {
							-- disable hybrid mode
							hybridMode = false,
						},
						typescript = {
							-- replace with your global TypeScript library path
							tsdk = "/usr/local/lib/node_modules/typescript/lib",
						},
					},
					-- find a local one if not use a global if you cannot fine one
					on_new_config = function(new_config, new_root_dir)
						local lib_path =
							vim.fs.find("node_modules/typescript/lib", { path = new_root_dir, upward = true })[1]
						if lib_path then
							new_config.init_options.typescript.tsdk = lib_path
						end
					end,
				},
				lua_ls = {
					-- cmd = {...},
					-- filetypes = { ...},
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
				-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#vale_ls
				vale_ls = {},
				-- https://writewithharper.com/docs/integrations/neovim
				harper_ls = {},
			}

			-- NOTE: `mason-lspconfig` must be setup before servers are configured
			require("mason-lspconfig").setup({
				-- ensure_installed = vim.tbl_keys(servers or {}),
				ensure_installed = {
					"ruff",
				},
				automatic_installation = {
					exclude = {
						"clangd",
						"solargraph",
						"sourcekit",
					},
				},
			})

			-- Must be setup after ``mason-lspconfig``. Doing this with
			-- {@link MasonLspconfigSettings.ensure_installed} and
			-- {@link MasonLspconfigSettings.automatic_installation} excluding
			-- server keys that are not in mason-lspconfig
			local lspconfig = require("lspconfig")
			for server_name, config in pairs(servers) do
				-- This handles overriding only values explicitly passed
				-- by the server configuration above. Useful when disabling
				-- certain features of an LSP (for example, turning off formatting for ts_ls)
				config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
				lspconfig[server_name].setup(config)
			end
		end,
	},
}
