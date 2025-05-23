---@module "lazy"
---@return LazyPluginSpec[]
return {
	{
		"github/copilot.vim",
		optional = true,
		config = function()
			-- Block the normal Copilot suggestions
			-- This setup and the callback is required for
			-- https://github.com/fang2hou/blink-copilot
			vim.api.nvim_create_augroup("github_copilot", { clear = true })
			vim.api.nvim_create_autocmd({ "FileType", "BufUnload" }, {
				group = "github_copilot",
				callback = function(args)
					vim.fn["copilot#On" .. args.event]()
				end,
			})
			vim.fn["copilot#OnFileType"]()
		end,
	},
	{
		"fang2hou/blink-copilot",
		version = "*",
		dependencies = {
			"github/copilot.vim",
		},
	},
	{
		"saghen/blink.cmp",
		optional = true,
		dependencies = { "fang2hou/blink-copilot" },
		opts_extend = { "sources.default", "completion.menu.draw.treesitter" },
		opts = {
			sources = {
				default = { "copilot" },
				per_filetype = {
					codecompanion = { "codecompanion" },
				},
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						score_offset = 100,
						async = true,
						opts = {
							max_completions = 3,
							max_attempts = 4,
							-- kind = "Copilot",
							debounce = 500, ---@type integer | false
							auto_refresh = {
								backward = true,
								forward = true,
							},
						},
					},
				},
			},
			completion = {
				menu = {
					draw = {
						treesitter = { "copilot" },
					},
				},
			},
		},
	},
}
