---@class Utils
local M = {}

-- https://www.lua.org/pil/17.1.html
-- Memoize Functions
---@type string[] if the computer goes by this name
local names = {}
setmetatable(names, { __mode = "kv" })

function M:is_win()
	return jit.os:find("Windows")
end

function M:is_mac()
	return jit.os:find("OSX")
end

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

_G.Utils = M

return _G.Utils
