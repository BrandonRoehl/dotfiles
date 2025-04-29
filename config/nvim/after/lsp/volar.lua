-- Will have to test why this was using a local var in their implementation
-- https://github.com/vuejs/language-tools/blob/master/packages/language-server/lib/types.ts
-- local volar_init_options = {}

local function get_typescript_server_path(root_dir)
	local project_root = vim.fs.dirname(vim.fs.find("node_modules", { path = root_dir, upward = true })[1])
	return project_root and vim.fs.joinpath(project_root, "node_modules", "typescript", "lib") or ""
end

return {
	cmd = { "vue-language-server", "--stdio" },
	filetypes = { "vue" },
	root_markers = { "package.json" },
	init_options = {
		vue = {
			-- disable hybrid mode
			hybridMode = false,
		},
		typescript = {
			tsdk = "",
		},
	},
	before_init = function(_, config)
		if
			not (config.init_options and config.init_options.typescript and config.init_options.typescript.tsdk == "")
		then
			return
		end

		local tsdk = get_typescript_server_path(config.root_dir)
		if not tsdk then
			-- Replace with your global TypeScript library path
			tsdk = "/usr/local/lib/node_modules/typescript/lib"
		end
		config.init_options.typescript.tsdk = tsdk
	end,
}
