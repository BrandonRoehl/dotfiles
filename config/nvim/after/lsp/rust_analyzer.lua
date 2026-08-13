return {
	settings = {
		["rust-analyzer"] = {
			cargo = {
				features = "all",
			},
			check = {
				command = "clippy",
			},
			diagnostics = {
				enable = true,
			},
		},
	},
}
