-- This is the entry point for sourcing
-- By default we load in alphabetical order but we need to source specs that
-- are extended first.

-- Inject our custom events and load our helpers that are required
-- Load custom helpers
require("utils")
-- Register custom events before setup
Utils.lazy.lazy_file()
Utils.lazy.register_custom_event("LazyDap", "LspPreEnable", "LspPostEnable")

---@module "lazy"
---@return LazyPluginSpec[]
return {
	-- Tier 1
	{ import = "plugins.mason" },
	{ import = "plugins.lsp" },
	{ import = "plugins.which-key" },
	{ import = "plugins.blink" },
	-- Tier 2
	{ import = "plugins.treesitter" },
	{ import = "plugins.dap" },
	-- Load everything else
	{ import = "plugins" },
}
