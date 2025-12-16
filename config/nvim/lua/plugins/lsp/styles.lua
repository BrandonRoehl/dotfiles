---@module "lazy"
---@type LazyPluginSpec
return {
	"neovim/nvim-lspconfig",
	optional = true,
	opts_extend = { "setup_extend" },
	opts = {
		--- @type vim.diagnostic.Opts
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
		---@type fun(self:LazyPlugin, opts:table)[]
		-- Will be executed when loading the plugin
		setup_extend = {
			function(_, opts)
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
			end,
		},
	},
}
