---@module "lazy"
---@type LazyPluginSpec
return {
	"neovim/nvim-lspconfig",
	optional = true,
	dependencies = {
		-- UI for actions
		"folke/snacks.nvim",
	},
	---@module "plugins.lsp"
	---@type LspOptions
	opts = {
		servers = {
			["*"] = {
                -- stylua: ignore
                ---@type LazyKeysLspSpec[]
				keys = {
                    -- { "K", vim.lsp.buf.hover, desc = "Hover" },
                    -- { "gd", vim.lsp.buf.definition, desc = "Goto Definition", method = "textDocument/definition" },
                    -- { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
                    -- { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
                    -- { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
                    -- { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
                    { "gK", function() return vim.lsp.buf.signature_help() end, desc = "Signature Help", method = "textDocument/signatureHelp" },
                    { "<c-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "Signature Help", method = "textDocument/signatureHelp" },
                    { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", method = "rename" },
                    { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" }, method = "textDocument/codeAction" },
                    { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "x" }, method = "textDocument/codeLens" },
                    { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" }, method = "textDocument/codeLens" },
                    { "<leader>ch>", function()
		            	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		            end, desc = "Toggle Inlay [C]ode [H]ints", method = "textDocument/inlayHint" },

                    -- Snacks pickers
                    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "[G]oto [D]efinition", method = "textDocument/definition" },
                    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "[G]oto [D]eclaration" },
                    { "gr", function() Snacks.picker.lsp_references() end, desc = "[R]eferences", nowait = true },
                    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "[G]oto [I]mplementation" },
                    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "[G]oto T[y]pe Definition" },
                    { "<leader>cl", function() Snacks.picker.lsp_config() end, desc = "Lsp Info" },
                    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP [S]ymbols" },
                    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace [S]ymbols" },
                    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", mode = {"n"}, method = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
                    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", method = "textDocument/documentHighlight" },
                    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", method = "textDocument/documentHighlight" },
                    { "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end, desc = "Next Reference", method = "textDocument/documentHighlight" },
                    { "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, desc = "Prev Reference", method = "textDocument/documentHighlight" },
                },
			},
		},
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
