return {
	settings = {
		-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
		gopls = {
			gofumpt = true,
			-- https://github.com/golang/tools/blob/master/gopls/doc/codelenses.md
			codelenses = {
				gc_details = false,
				generate = true,
				regenerate_cgo = true,
				-- run_govulncheck = true,
				test = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
			-- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			-- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
			-- analyses = {},
			usePlaceholders = true,
			-- staticcheck = true,
			directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
			semanticTokens = true,
		},
	},
}
