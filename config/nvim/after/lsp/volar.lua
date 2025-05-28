local util = require("lspconfig.util")

local function get_typescript_server_path(root_dir, default)
	local tsdk = util.get_typescript_server_path(root_dir) or default
	-- Return the value if it exists else empty string
	return vim.uv.fs_stat(tsdk) and tsdk or ""
end

return {
	cmd = { "vue-language-server", "--stdio" },
	filetypes = { "vue" },
	root_markers = { "package.json" },
	-- https://github.com/vuejs/language-tools/blob/v2/packages/language-server/lib/types.ts
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
		if vim.tbl_get(config, "init_options", "typescript", "tsdk") ~= "" then
			return
		end

		config.init_options.typescript.tsdk =
			get_typescript_server_path(config.root_dir, "/usr/local/lib/node_modules/typescript/lib")
	end,
}
