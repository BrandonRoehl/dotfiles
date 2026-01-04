---@class utils.computer
local M = {}

-- https://www.lua.org/pil/17.1.html
-- Memoize Functions
---@type string[] if the computer goes by this name
M._host = {}
setmetatable(M._host, { __mode = "kv" })

---@param func fun(name:string):boolean callback to run for each computer name
---@return boolean true if the computer name matches
function M:host_matches(func)
	-- Cache the lookup of names so future checks are quicker
	if #self._host == 0 then
		self._host = { vim.fn.hostname() }
		-- On macOS, get the computer name instead of just the hostname
		if vim.fn.executable("scutil") == 1 then
			local obj = vim.system({ "scutil", "--get", "ComputerName" }, { text = true }):wait()
			if obj.code == 0 then
				local out, _ = string.gsub(obj.stdout, "\n$", "")
				table.insert(self._host, out)
			end
		end
	end

	return vim.tbl_contains(self._host, func, { predicate = true })
end

---@param ... string computer name if found else hostname
---@return boolean true if the computer name matches
function M:is_host(...)
	local checks = { ... }
	return self:host_matches(function(name)
		return vim.list_contains(checks, name)
	end)
end

---@param pattern string pattern to match against host names
---@return boolean true if the computer name matches
function M:host_contains(pattern)
	return self:host_matches(function(name)
		return string.match(pattern, name) ~= nil
	end)
end

return M
