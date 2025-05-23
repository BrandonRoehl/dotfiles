-- Format
---@module "lazy"
---@return LazyPluginSpec[]
return {
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		lazy = true,
		enabled = false,
		dependencies = "mason-org/mason.nvim",
		opts_extend = { "ensure_installed" },
		opts = {
			-- Tools to auto install and instead use from the env
			ensure_installed = {},
		},
	},
	{
		"stevearc/conform.nvim",
		dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
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
			formatters_by_ft = {},
		},
	},
}
