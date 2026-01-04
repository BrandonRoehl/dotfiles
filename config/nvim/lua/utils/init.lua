---@class utils
---@field treesitter utils.treesitter
---@field lsp utils.lsp
---@field computer utils.computer
---@field lazy utils.lazy
local M = {}

setmetatable(M, {
	__mode = "kv",
	__index = function(t, k)
		---@diagnostic disable-next-line: no-unknown
		t[k] = require("utils." .. k)
		return rawget(t, k)
	end,
})

_G.Utils = M

return M
