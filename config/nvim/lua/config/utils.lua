---@class Utils
local M = {}

function M:is_win()
	return jit.os:find("Windows") or vim.fn.has("win32") == 1
end

function M:is_mac()
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
---@param name string the event name to add
function M:register_custom_event(name)
	local Event = require("lazy.core.handler.event")

	Event.mappings[name] = { id = name, event = "User", pattern = name }
	Event.mappings["User " .. name] = Event.mappings[name]
end

function M:trigger_custom_event(name)
	vim.api.nvim_exec_autocmds("User", { pattern = name })
end

_G.Utils = M

return _G.Utils
