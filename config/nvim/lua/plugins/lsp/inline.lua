if vim.fn.has("nvim-0.12") == 0 then
	return {}
end

---@module "lazy"
---@type LazyPluginSpec
return {
	"neovim/nvim-lspconfig",
	optional = true,
	opts_extend = { "servers.*.keys" },
	---@type LspOptions
	opts = {
		servers = {
			["*"] = {
                -- stylua: ignore
                ---@type LazyKeysLspSpec[]
				keys = {
                    { "<c-f>", vim.lsp.inline_completion.get, mode = "i", desc = "Accept inline completion", method = "textDocument/inlineCompletion" },
                    { "<c-g>", vim.lsp.inline_completion.select, mode = "i", desc = "Switch inline completion", method = "textDocument/inlineCompletion" },
                },
			},
		},
	},
}
