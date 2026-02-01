local util = require("lspconfig.util")

---@type vim.lsp.Config
return {
	root_dir = function(bufnr, on_dir)
		local filename = vim.api.nvim_buf_get_name(bufnr)
		on_dir(
			util.root_pattern("buildServer.json", ".bsp")(filename)
				or util.root_pattern("*.xcodeproj", "*.xcworkspace")(filename)
				-- better to keep it at the end, because some modularized apps contain multiple Package.swift files
				or util.root_pattern("compile_commands.json", "Package.swift")(filename)
		)
	end,
	workspace_required = true,
}
