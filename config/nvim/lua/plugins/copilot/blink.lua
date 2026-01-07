if vim.fn.has("nvim-0.12") == 1 then
	return {}
end

---@module "lazy"
---@return LazyPluginSpec[]
return {
	"saghen/blink.cmp",
	optional = true,
	-- Inject blink copilot and configure it if blink is enabled elsewhere
	dependencies = {
		"fang2hou/blink-copilot",
		lazy = true,
		version = "*",
	},
	opts_extend = { "sources.default", "completion.menu.draw.treesitter" },
	opts = {
		sources = {
			default = { "copilot" },
			providers = {
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					score_offset = -10,
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
}
