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
		opts_extend = { "servers.*.keys" },
		---@module "plugins.lsp"
		---@type LspOptions lsp options
		opts = {
			servers = {
				["*"] = {
                    -- stylua: ignore
					keys = {
                        { "]]",    function() Snacks.words.jump(vim.v.count1)        end, desc = "Next Reference", mode = { "n", "t" }, method = "textDocument/documentHighlight" },
                        { "[[",    function() Snacks.words.jump(-vim.v.count1)       end, desc = "Prev Reference", mode = { "n", "t" }, method = "textDocument/documentHighlight" },
                        { "<a-n>", function() Snacks.words.jump(vim.v.count1, true)  end, desc = "Next Reference", mode = { "n", "t" }, method = "textDocument/documentHighlight" },
                        { "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, desc = "Prev Reference", mode = { "n", "t" }, method = "textDocument/documentHighlight" },
                    },
				},
			},
		},
	},
}
