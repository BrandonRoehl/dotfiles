--- @module 'lazy'
--- @return LazyPluginSpec[]
return {
	--- @return LazyPluginSpec
	{ -- Highlight todo, notes, etc in comments
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = vim.g.have_nerd_font,
			keywords = {
				FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
				TODO = { icon = " ", color = "info" },
				HACK = { icon = " ", color = "warning" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
				PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				NOTE = { icon = " ", color = "hint", alt = { "INFO", "MARK" } },
				TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
			},
		},
	},
	--- @type LazyPluginSpec
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		init = function()
			vim.g.lualine_laststatus = vim.o.laststatus
			if vim.fn.argc(-1) > 0 then
				-- set an empty statusline till lualine loads
				vim.o.statusline = " "
			else
				-- hide the statusline on the starter page
				vim.o.laststatus = 0
			end
		end,
		opts = function()
			-- PERF: we don't need this lualine require madness 🤷
			local lualine_require = require("lualine_require")
			lualine_require.require = require

			-- local icons = LazyVim.config.icons

			vim.o.laststatus = vim.g.lualine_laststatus

			local opts = {
				options = {
					theme = "auto",
					icons_enabled = vim.g.have_nerd_font,
					globalstatus = vim.o.laststatus == 3,
					-- component_separators = vim.g.have_nerd_font and { left = "", right = "" }
					-- 	or { left = "│", right = "│" },
					-- section_separators = vim.g.have_nerd_font and { left = "", right = "" }
					-- 	or { left = "", right = "" },
					component_separators = { left = "│", right = "│" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" },
						winbar = {},
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = {
						"diagnostics",
						"filetype",
						"filename",
					},
					lualine_x = {
						Snacks.profiler.status(),
						-- stylua: ignore
						-- {
						-- 	function() return require("noice").api.status.command.get() end,
						-- 	cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
						-- 	color = function() return { fg = Snacks.util.color("Statement") } end,
						-- },
						-- -- stylua: ignore
						-- {
						-- 	function() return require("noice").api.status.mode.get() end,
						-- 	cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
						-- 	color = function() return { fg = Snacks.util.color("Constant") } end,
						-- },
						-- stylua: ignore
						{
							function() return "  " .. require("dap").status() end,
							cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
							color = function() return { fg = Snacks.util.color("Debug") } end,
						},
						-- stylua: ignore
						{
							require("lazy.status").updates,
							cond = require("lazy.status").has_updates,
							color = function() return { fg = Snacks.util.color("Special") } end,
						},
						{
							"diff",
							-- symbols = {
							-- 	added = icons.git.added,
							-- 	modified = icons.git.modified,
							-- 	removed = icons.git.removed,
							-- },
							source = function()
								local gitsigns = vim.b.gitsigns_status_dict
								if gitsigns then
									return {
										added = gitsigns.added,
										modified = gitsigns.changed,
										removed = gitsigns.removed,
									}
								end
							end,
						},
						-- This will be replaced by the actual component in the config function
						-- this is registered in `lua/lualine/components`
						"codecompanion",
					},
					lualine_y = {
						"encoding",
						"fileformat",
					},
					lualine_z = {
						{ "progress", separator = " ", padding = { left = 1, right = 0 } },
						{ "location", padding = { left = 0, right = 1 } },
						-- function()
						-- 	return " " .. os.date("%R")
						-- end,
					},
				},
				extensions = { "lazy", "mason", "fzf", "neo-tree", "nvim-dap-ui" },
			}

			return opts
		end,
	},
}
-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
-- require("mini.ai").setup({ n_lines = 500 })

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
-- require("mini.surround").setup()
