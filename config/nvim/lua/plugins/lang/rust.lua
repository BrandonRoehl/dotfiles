---@module "lazy"

local function expand_macro()
	local client = vim.lsp.get_clients({ bufnr = 0, name = "rust_analyzer" })[1]
	if not client then
		vim.notify("rust-analyzer is not attached to this buffer", vim.log.levels.WARN)
		return
	end

	local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
	client:request("rust-analyzer/expandMacro", params, function(err, result)
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
	end, 0)
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
