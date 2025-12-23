return {
	-- cmd = {...},
	-- filetypes = { ...},
	-- capabilities = {},
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
			-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
			diagnostics = { disable = { "missing-fields" } },
			format = {
				-- using stylua instead so disabling this
				enable = false,
				-- defaultConfig = {
				--     indent_style = "space",
				--     indent_size = "4",
				--     continuation_indent_size = "4",
				-- },
			},
		},
	},
}
