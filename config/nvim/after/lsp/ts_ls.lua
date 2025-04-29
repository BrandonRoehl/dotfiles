return {
	--- @type lsp.ClientCapabilities
	capabilities = {
		textDocument = {
			formatting = nil,
		},
	},
	init_options = {
		plugins = { -- I think this was my breakthrough that made it work
			{
				name = "@vue/typescript-plugin",
				location = "/usr/local/lib/node_modules/@vue/language-server",
				languages = { "vue" },
			},
		},
	},
	before_init = function(_, config)
		local lib_path = vim.fs.find("node_modules/@vue/language-server", { path = config.root_dir, upward = true })[1]
		if lib_path then
			config.init_options.plugins[0].location = lib_path
		end
	end,
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
}
