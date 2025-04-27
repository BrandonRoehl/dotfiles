-- Format
--- @return LazyPluginSpec[]
return {
	--- @type LazyPluginSpec
	{ -- Autoformat
		"stevearc/conform.nvim",
		version = "*",
		dependencies = {
			{ "williamboman/mason.nvim" }, -- NOTE: Must be added on the top level
			{
				"WhoIsSethDaniel/mason-tool-installer.nvim",
				opts = {
					-- Tools to auto install and instead use from the env
					ensure_installed = {
						"stylua", -- Used to format Lua code
						-- "black", -- Used to format Python code
						-- "isort", -- Used to sort Python imports
						"rustfmt", -- Used to format Rust code
						-- "eslint", -- Used to lint JavaScript and TypeScript
						-- "prettier", -- Used to format JavaScript and TypeScript
					},
				},
			},
		},
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>=",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				local lsp_format_opt
				if disable_filetypes[vim.bo[bufnr].filetype] then
					lsp_format_opt = "never"
				else
					lsp_format_opt = "fallback"
				end
				return {
					timeout_ms = 500,
					lsp_format = lsp_format_opt,
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform can also run multiple formatters sequentially
				-- python = { "isort", "black" },
				rust = { "rustfmt" },
				--
				-- You can use 'stop_after_first' to run the first available formatter from the list
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				vue = { "prettierd", "prettier", stop_after_first = true },
			},
		},
	},
}
