---@module "lazy"
---@return LazyPluginSpec
return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"folke/snacks.nvim",
	},
	lazy = true,
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

		vim.o.laststatus = vim.g.lualine_laststatus

		local filename = {
			"filename",
			-- Displays file status (readonly, modified)
			file_status = true,
			-- Display new file status
			newfile_status = false,
			-- 0: Just filename, 1: Relative path, 2: Absolute path, 3: Absolute path with tilde, 4: Filename + parent dir
			path = 1,
			-- Shortens path if it breaks the line
			shorting_target = 40,
		}

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
					filename,
				},
				lualine_x = {
					-- This will be replaced by the actual component in the config function
					-- this is registered in `lua/lualine/components`
					"codecompanion",
					Snacks.profiler.status(),
					-- stylua: ignore
					{
						function() return require("noice").api.status.command.get() end,
						cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
						color = function() return { fg = Snacks.util.color("Statement") } end,
					},
					-- stylua: ignore
					{
						function() return require("noice").api.status.mode.get() end,
						cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
						color = function() return { fg = Snacks.util.color("Constant") } end,
					},
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
					"fileformat",
					"encoding",
				},
				lualine_y = {
					"progress",
					-- { "progress", separator = " ", padding = { left = 1, right = 0 } },
					-- { "location", padding = { left = 0, right = 1 } },
				},
				lualine_z = {
					"location",
					-- function()
					-- 	return " " .. os.date("%R")
					-- end,
				},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { filename },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			extensions = { "lazy", "mason", "fzf", "neo-tree", "nvim-dap-ui" },
		}

		return opts
	end,
}
