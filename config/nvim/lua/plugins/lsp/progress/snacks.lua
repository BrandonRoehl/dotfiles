local M = {
	---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
	progress = vim.defaulttable(),
}

---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
function M.callback(ev)
	-- Guard that snacks is enabled otherwise this will create a ton of notifications
	if not package.loaded["snacks"] then
		return
	end
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
	if not client or type(value) ~= "table" then
		return
	end
	local p = M.progress[client.id]

	for i = 1, #p + 1 do
		if i == #p + 1 or p[i].token == ev.data.params.token then
			p[i] = {
				token = ev.data.params.token,
				msg = ("[%3d%%] %s%s"):format(
					value.kind == "end" and 100 or value.percentage or 100,
					value.title or "",
					value.message and (" **%s**"):format(value.message) or ""
				),
				done = value.kind == "end",
			}
			break
		end
	end

	local msg = {} ---@type string[]
	M.progress[client.id] = vim.tbl_filter(function(v)
		return table.insert(msg, v.msg) or not v.done
	end, p)

	local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
	vim.notify(table.concat(msg, "\n"), "info", {
		id = "lsp_progress",
		title = client.name,
		opts = function(notif)
			notif.icon = #M.progress[client.id] == 0 and " "
				or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
		end,
	})
end

---@param group integer?
function M:create_autocmd(group)
	vim.api.nvim_create_autocmd("LspProgress", {
		group = group or vim.api.nvim_create_augroup("lazy-lsp-progress", { clear = true }),
		callback = M.callback,
	})
end

return M
