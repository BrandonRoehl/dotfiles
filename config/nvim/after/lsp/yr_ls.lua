---@type vim.lsp.Config
return {
	cmd = { "yr-ls" },
	filetypes = { "yara", "yar" },
	root_markers = { "Makefile", ".git" },
}
