---@module "lazy"

local function expand_macro()
	local bufnr = vim.api.nvim_get_current_buf()
	local win = vim.api.nvim_get_current_win()
	local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "rust_analyzer" })

	for _, client in ipairs(clients) do
		local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
		if
			client:supports_method("rust-analyzer/expandMacro", bufnr)
			and client:request("rust-analyzer/expandMacro", params, function(err, result)
				if err then
					vim.notify("Expand macro failed: " .. (err.message or vim.inspect(err)), vim.log.levels.ERROR)
					return
				end
				if not result or not result.expansion or result.expansion == "" then
					vim.notify("No macro under cursor", vim.log.levels.INFO)
					return
				end
				vim.lsp.util.open_floating_preview(vim.split(result.expansion, "\n", { trimempty = true }), "rust", {
					title = " " .. (result.name or "Macro expansion") .. " ",
					border = "rounded",
				})
			end, bufnr)
		then
			return
		end
	end
	vim.notify("rust-analyzer is not attached to this buffer", vim.log.levels.WARN)
end

---@return LazyPluginSpec[]
return {
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts = {
			ensure_installed = { "rust", "ron" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts = {
			servers = {
				rust_analyzer = {
					keys = {
						{
							"<leader>cx",
							expand_macro,
							desc = "Expand macro",
						},
					},
				},
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		optional = true,
		opts = {
			ensure_installed = { "rust_analyzer" },
		},
	},
	-- {
	-- 	"mason-org/mason.nvim",
	-- 	optional = true,
	-- 	opts = {
	-- 		ensure_installed = { "rustfmt" },
	-- 	},
	-- },
	-- {
	-- 	"stevearc/conform.nvim",
	-- 	optional = true,
	-- 	opts = {
	-- 		formatters_by_ft = {
	-- 			rust = { "rustfmt" },
	-- 		},
	-- 	},
	-- },
}
