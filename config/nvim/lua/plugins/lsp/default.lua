---@module "lazy"
---@type LazyPluginSpec
return {
	"neovim/nvim-lspconfig",
	optional = true,
	---@type LspOptions
	opts = {
		servers = {
			["*"] = {
				keys = {},
			},
		},
		diagnostics = {
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
