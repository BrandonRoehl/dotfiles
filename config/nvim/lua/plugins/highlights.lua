local function get_color_item(ctx)
	-- If LSP source and you have `nvim-highlight-colors` loaded, check for
	-- color derived from documentation
	if package.loaded["nvim-highlight-colors"] and ctx.item.source_name == "LSP" then
		return require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
	end
	return nil
end

-- Block highlights text detected as colors e.g. #ffffff
-- Come back to this when this is added for real
-- https://github.com/neovim/neovim/pull/33440
---@module "lazy"
---@return LazyPluginSpec[]
return {
	"brenoprata10/nvim-highlight-colors",
	lazy = true,
	event = "VeryLazy",
	cmd = "HighlightColors",
	opts = {
		render = "virtual",
	},
	specs = {
		"saghen/blink.cmp",
		optional = true,
		opts = {
			completion = {
				menu = {
					draw = {
						components = {
							kind_icon = {
								text = function(ctx)
									-- Default kind icon
									local icon = ctx.kind_icon
									-- See if there is a colored icon
									local color_item = get_color_item(ctx)
									if color_item and color_item.abbr ~= "" then
										icon = color_item.abbr
									end
									return icon .. ctx.icon_gap
								end,
								highlight = function(ctx)
									local color_item = get_color_item(ctx)
									if color_item and color_item.abbr_hl_group then
										return color_item.abbr_hl_group
									end
									return "BlinkCmpKind" .. ctx.kind
								end,
							},
						},
					},
				},
			},
		},
	},
}
