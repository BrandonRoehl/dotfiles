local function get_vue_path(root_dir, default)
	local project_root = vim.fs.dirname(vim.fs.find("node_modules", { path = root_dir, upward = true })[1])
	local vuels = project_root and vim.fs.joinpath(project_root, "node_modules", "@vue", "language-server") or default
	-- Return the value if it exists else empty string
	return vim.uv.fs_stat(vuels) and vuels or ""
end

local vue_plugin = {
	name = "@vue/typescript-plugin",
	location = "",
	languages = { "vue" },
}

return {
	--- @type lsp.ClientCapabilities
	capabilities = {
		textDocument = {
			formatting = nil,
		},
	},
	init_options = {
		plugins = nil,
	},
	before_init = function(_, config)
		-- Check that we haven't set anything yet
		if not config.init_options or config.init_options.plugins then
			return
		end

		local lib_path = get_vue_path(config.root_dir, "/usr/local/lib/node_modules/@vue/language-server")
		-- Maybe add an exists check here
		if lib_path then
			vue_plugin.location = lib_path
			config.init_options.plugins = { vue_plugin }
		else
			config.init_options.plugins = {}
		end
	end,
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
}
