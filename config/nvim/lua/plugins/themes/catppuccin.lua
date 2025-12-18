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
		default_integrations = true,
		integrations = {
			blink_cmp = true,
			dap = true,
			dap_ui = true,
			dashboard = true,
			gitsigns = true,
			neotree = true,
			treesitter = true,
			treesitter_context = true,
			copilot_vim = true,
			hop = true,
			mason = true,
			fidget = true,
			semantic_tokens = true,
			snacks = {
				enabled = true,
			},
			which_key = true,
			notify = true,
			noice = true,
			-- telescope = {
			-- 	enabled = true,
			-- 	style = vim.g.winborder == "none" and "nvchad" or "classic",
			-- },
			-- native_lsp = {
			-- 	enabled = true,
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
			-- },
		},
		-- custom_highlights = function(colors)
		-- 	return {
		-- 		NormalFloat = { fg = colors.text, bg = colors.mantle }, -- Normal text in floating windows.
		-- 		FloatBorder = { fg = colors.blue, bg = colors.mantle },
		-- 		FloatTitle = { fg = colors.subtext0, bg = colors.mantle }, -- Title of floating windows
		-- 		TelescopeBorder = { fg = colors.blue, bg = colors.none }, -- Border of the telescope window
		-- 	}
		-- end,
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
	end,
	init = function()
		vim.cmd.colorscheme("catppuccin")
	end,
}
