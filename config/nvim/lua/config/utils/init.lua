local LazyUtil = require("lazy.core.util")

---@class Utils: LazyUtilCore
---@field treesitter utils.treesitter
local M = {}

setmetatable(M, {
	__index = function(t, k)
		if LazyUtil[k] then
			return LazyUtil[k]
		end
		---@diagnostic disable-next-line: no-unknown
		t[k] = require("config.utils." .. k)
		return t[k]
	end,
})

function M.is_win()
	return jit.os:find("Windows") or vim.fn.has("win32") == 1
end

function M.is_mac()
	return jit.os:find("OSX")
end

-- https://www.lua.org/pil/17.1.html
-- Memoize Functions
---@type string[] if the computer goes by this name
local names = {}
setmetatable(names, { __mode = "kv" })

---@param ... string computer name if found else hostname
---@return boolean true if the computer name matches
function M:is_computer(...)
	-- Cache the lookup of names so future checks are quicker
	if #names == 0 then
		names = { vim.fn.hostname() }
		-- On macOS, get the computer name instead of just the hostname
		if M:is_mac() then
			local obj = vim.system({ "scutil", "--get", "ComputerName" }, { text = true }):wait()
			if obj.code == 0 then
				local out, _ = string.gsub(obj.stdout, "\n$", "")
				table.insert(names, out)
			end
		end
	end

	return vim.tbl_contains({ ... }, function(name)
		return vim.list_contains(names, name)
	end, { predicate = true })
end

-- Add support for custom event to lazy nvim
---@param ... string the event names to add
function M:register_custom_event(...)
	local Event = require("lazy.core.handler.event")
	for _, name in ipairs({ ... }) do
		Event.mappings[name] = { id = name, event = "User", pattern = name }
		Event.mappings["User " .. name] = Event.mappings[name]
	end
end

-- Trigger the custom event and load all plugins that are waiting on it
function M:trigger_custom_event(name)
	vim.api.nvim_exec_autocmds("User", { pattern = name })
end

---@param name string
---@return LazyPlugin|nil plugin if the plugin is configured
function M:plugin_spec(name)
	return require("lazy.core.config").spec.plugins[name]
end

---@param name string
function M:plugin_opts(name)
	local plugin = M:plugin_spec(name)
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
	local spec = M:plugin_spec(name)
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
		return M:has_plugin(name)
	end
end

_G.Utils = M

return M
