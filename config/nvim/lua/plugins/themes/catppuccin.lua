---@module "lazy"
---@return LazyPluginSpec
return {
	"catppuccin/nvim",
	enabled = true,
	lazy = false,
	version = false,
	priority = 1000,
	---@module 'catppuccin'
	---@type CatppuccinOptions
	opts = {
		flavour = "auto",
		background = {
			light = "latte",
			dark = "mocha",
		},
		auto_integrations = true,
		integrations = {
			blink_cmp = true,
			dap = true,
			dap_ui = true,
			gitsigns = true,
			treesitter = true,
			treesitter_context = true,
			copilot_vim = true,
			hop = true,
			mason = true,
			fidget = true,
			semantic_tokens = true,
			snacks = {
				enabled = true,
				-- indent_scope_color = "teal",
				-- indent_scope_color = "rosewater",
			},
			-- indent_blankline = {
			-- 	enabled = true,
			-- 	scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
			-- 	colored_indent_levels = true,
			-- },
			which_key = true,
			notify = true,
			noice = true,
			telescope = {
				enabled = true,
				style = "nvchad",
				-- style = "classic",
			},
			native_lsp = {
				enabled = true,
				-- 	virtual_text = {
				-- 		errors = { "italic" },
				-- 		hints = { "italic" },
				-- 		warnings = { "italic" },
				-- 		information = { "italic" },
				-- 		ok = { "italic" },
				-- 	},
				-- 	underlines = {
				-- 		errors = { "underline" },
				-- 		hints = { "underline" },
				-- 		warnings = { "underline" },
				-- 		information = { "underline" },
				-- 		ok = { "underline" },
				-- 	},
				-- 	inlay_hints = {
				-- 		background = true,
				-- 	},
			},
		},
		-- custom_highlights = function(colors)
		-- 	return {
		-- 		NormalFloat = { fg = colors.text, bg = colors.mantle }, -- Normal text in floating windows.
		-- 		FloatBorder = { fg = colors.blue, bg = colors.mantle },
		-- 		FloatTitle = { fg = colors.subtext0, bg = colors.mantle }, -- Title of floating windows
		-- 		TelescopeBorder = { fg = colors.blue, bg = colors.none }, -- Border of the telescope window
		-- 	}
		-- end,
		-- custom_highlights = function(colors)
		-- 	return {
		-- 		SnacksIndent1 = { fg = colors.red },
		-- 		SnacksIndent2 = { fg = colors.yellow },
		-- 		SnacksIndent3 = { fg = colors.blue },
		-- 		SnacksIndent4 = { fg = colors.peach },
		-- 		SnacksIndent5 = { fg = colors.green },
		-- 		SnacksIndent6 = { fg = colors.mauve },
		-- 		SnacksIndent7 = { fg = colors.teal },
		-- 		SnacksIndent8 = { fg = colors.lavender },
		-- 	}
		-- end,
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
	end,
	init = function()
		vim.cmd.colorscheme("catppuccin-nvim")
	end,
}
