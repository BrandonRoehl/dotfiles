---@class utils.computer
local M = {
	-- https://www.lua.org/pil/17.1.html
	-- Memoize Functions
	---@type string[] if the computer goes by this name
	__host = {},
}
setmetatable(M.__host, { __mode = "kv" })

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
	if #self.__host == 0 then
		self.__host = { vim.fn.hostname() }
		-- On macOS, get the computer name instead of just the hostname
		if self.is_mac() then
			local obj = vim.system({ "scutil", "--get", "ComputerName" }, { text = true }):wait()
			if obj.code == 0 then
				local out, _ = string.gsub(obj.stdout, "\n$", "")
				table.insert(self.__host, out)
			end
		end
	end

	return vim.tbl_contains({ ... }, function(name)
		return vim.list_contains(self.__host, name)
	end, { predicate = true })
end

return M
