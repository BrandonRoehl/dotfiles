---@module "lazy"
---@class utils.lazy
local M = {}

-- Add support for custom event to lazy nvim
---@param ... string the event names to add
function M.register_custom_event(...)
	local Event = require("lazy.core.handler.event")
	for _, name in ipairs({ ... }) do
		Event.mappings[name] = { id = name, event = "User", pattern = name }
		Event.mappings["User " .. name] = Event.mappings[name]
	end
end

-- Trigger the custom event and load all plugins that are waiting on it
function M.trigger_custom_event(name)
	vim.api.nvim_exec_autocmds("User", { pattern = name })
end

-- Add support for the LazyFile event
function M.lazy_file()
	local Event = require("lazy.core.handler.event")

	Event.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
	Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

---@param name string
---@return LazyPlugin|nil plugin if the plugin is configured
function M.plugin_spec(name)
	return require("lazy.core.config").spec.plugins[name]
end

---@param name string
function M:plugin_opts(name)
	local plugin = self.plugin_spec(name)
	if not plugin then
		return {}
	end
	local Plugin = require("lazy.core.plugin")
	return Plugin.values(plugin, "opts", false)
end

-- Plugin
---@param name string
---@return boolean result if the plugin is configured
function M:has_plugin(name)
	local spec = M.plugin_spec(name)
	-- Plugin spec exists
	return spec ~= nil
		-- Plugin spec is not disabled (enabled or nil)
		and not (spec.enabled == false or (type(spec.enabled) == "function" and not spec.enabled()))
		-- Plugin spec has at least one non optional source
		and not spec.optional
end

-- Lazy evaluate whether or not to enable this plugin by currying the result
---@param name string of the plugin to enable with
---@return fun():boolean check returning if the plugin should be enabled
function M:enable_with(name)
	return function()
		return self:has_plugin(name)
	end
end

return M
