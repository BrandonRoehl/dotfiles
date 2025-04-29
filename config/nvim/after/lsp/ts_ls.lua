local vue_plugin = {
	name = "@vue/typescript-plugin",
	location = "/usr/local/lib/node_modules/@vue/language-server",
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

		local lib_path = vim.fs.find("node_modules/@vue/language-server", { path = config.root_dir, upward = true })[1]
		if lib_path then
			vue_plugin.location = lib_path
		end
		if vim.fs.exists(lib_path) then
			config.init_options.plugins = { vue_plugin }
		else
			config.init_options.plugins = {}
		end
	end,
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
}
