return {
	-- https://github.com/microsoft/pyright/blob/main/docs/settings.md
	settings = {
		single_file_support = true,
		python = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
				typeCheckingMode = "basic",
			},
		},
	},
}
