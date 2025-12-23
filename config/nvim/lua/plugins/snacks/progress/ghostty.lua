local M = {}

---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
local function callback(ev)
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	local value = ev.data.params.value
	if not client or type(value) ~= "table" then
		return
	end
	-- https://conemu.github.io/en/AnsiEscapeCodes.html#ConEmu_specific_OSC
	-- https://ghostty.org/docs/vt/osc/conemu
	-- ESC ] 9 ; 4 ; st ; pr ST
	local percentage = value.kind == "end" and 100 or value.percentage or 100
	local mode = percentage == 100 and 0 or 1
	local sequence = "\x1B]9;4;" .. mode .. ";" .. percentage .. "\x1B\x5C"
	io.stdout:write(sequence)
end

---@param group integer?
function M.create_autocmd(group)
	group = group or vim.api.nvim_create_augroup("lazy-lsp-progress", { clear = true })
	vim.api.nvim_create_autocmd("LspProgress", {
		group = group,
		callback = callback,
	})
	vim.api.nvim_create_autocmd("VimLeave", {
		group = group,
		callback = function()
			io.stdout:write("\x1B]9;4;0\x1B\x5C")
		end,
	})
end

return M
