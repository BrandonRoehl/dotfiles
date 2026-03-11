---@module "lazy"
---@type LazyPluginSpec
return {
	"folke/snacks.nvim",
	optional = true,
	--- @module 'snacks'
	--- @type snacks.Config
	opts = {
		words = { enabled = true },
	},
	-- stylua: ignore
	-- keys = {
	-- 	{ "]]", function() Snacks.words.jump(vim.v.count1)  end, desc = "Next Reference", mode = { "n", "t" } },
	-- 	{ "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
	--    },
	specs = {
		"neovim/nvim-lspconfig",
		optional = true,
		dependencies = { "folke/snacks.nvim" },
		---@module "plugins.lsp"
		---@type LspOptions lsp options
		opts = {
			servers = {
				["*"] = {
                    -- stylua: ignore
					keys = {
                        { "]]",    function() Snacks.words.jump(vim.v.count1)        end, desc = "Next Reference", mode = { "n", "t" }, method = "textDocument/documentHighlight", enabled = Snacks.words.is_enabled() },
                        { "[[",    function() Snacks.words.jump(-vim.v.count1)       end, desc = "Prev Reference", mode = { "n", "t" }, method = "textDocument/documentHighlight", enabled = Snacks.words.is_enabled() },
                        { "<a-n>", function() Snacks.words.jump(vim.v.count1, true)  end, desc = "Next Reference", mode = { "n", "t" }, method = "textDocument/documentHighlight", enabled = Snacks.words.is_enabled() },
                        { "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, desc = "Prev Reference", mode = { "n", "t" }, method = "textDocument/documentHighlight", enabled = Snacks.words.is_enabled() },
                    },
				},
			},
		},
	},
}
