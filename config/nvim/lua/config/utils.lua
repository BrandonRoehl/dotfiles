---@class Utils
local M = {
	---@type string[] computer names this computer goes by
	names = {},
}

---@param ... string computer name if found else hostname
---@return boolean true if the computer name matches
function M:is_computer(...)
	-- Cache the lookup of names so future checks are quicker
	if #M.names == 0 then
		M.names = { vim.fn.hostname() }
		-- On macOS, get the computer name instead of just the hostname
		if vim.fn.has("macunix") then
			local obj = vim.system({ "scutil", "--get", "ComputerName" }, { text = true }):wait()
			if obj.code == 0 then
				local out, _ = string.gsub(obj.stdout, "\n$", "")
				table.insert(M.names, out)
			end
		end
	end

	return vim.tbl_contains({ ... }, function(name)
		return vim.list_contains(M.names, name)
	end, { predicate = true })
end

_G.Utils = M

return _G.Utils
