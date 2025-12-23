---@class utils.computer
local M = {}

-- https://www.lua.org/pil/17.1.html
-- Memoize Functions
---@type string[] if the computer goes by this name
M._host = {}
setmetatable(M._host, { __mode = "kv" })

function M.is_win()
	return jit.os:find("Windows") or vim.fn.has("win32") == 1
end

function M.is_mac()
	return jit.os:find("OSX")
end

---@param ... string computer name if found else hostname
---@return boolean true if the computer name matches
function M:is_host(...)
	-- Cache the lookup of names so future checks are quicker
	if #self._host == 0 then
		self._host = { vim.fn.hostname() }
		-- On macOS, get the computer name instead of just the hostname
		if self.is_mac() then
			local obj = vim.system({ "scutil", "--get", "ComputerName" }, { text = true }):wait()
			if obj.code == 0 then
				local out, _ = string.gsub(obj.stdout, "\n$", "")
				table.insert(self._host, out)
			end
		end
	end

	return vim.tbl_contains({ ... }, function(name)
		return vim.list_contains(self._host, name)
	end, { predicate = true })
end

return M
