local M = {
	progress = vim.defaulttable(),
}

function M:init()
	local group = vim.api.nvim_create_augroup("CodeCompanionSnacksHooks", { clear = true })

	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = { "CodeCompanionRequestStarted", "CodeCompanionRequestStreaming" },
		group = group,
		callback = function(request)
			M.progress[request.data.id] = request

			---@type string[]
			local msg = {
				" Requesting assistance (" .. request.data.strategy .. ")",
				M:llm_role_title(request.data.adapter),
			}
			local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
			vim.notify(table.concat(msg, "\n"), "info", {
				id = request.data.id,
				title = request.data.adapter.name,
				opts = function(notif)
					notif.icon = #M.progress[request.data.id] == 0 and " "
						or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
				end,
			})
		end,
	})

	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = "CodeCompanionRequestFinished",
		group = group,
		callback = function(request)
			M.progress[request.data.id] = nil

			local status = M:exit_status(request)
			vim.notify(status.msg, status.level, {
				id = request.data.id,
				title = request.data.adapter.name,
				opts = function(notif)
					notif.icon = status.icon
				end,
			})
		end,
	})
end

function M:llm_role_title(adapter)
	local parts = {}
	table.insert(parts, adapter.formatted_name)
	if adapter.model and adapter.model ~= "" then
		table.insert(parts, "(" .. adapter.model .. ")")
	end
	return table.concat(parts, " ")
end

---@return {msg: string, level?: number|"debug"|"error"|"info"|"trace", icon: string}
function M:exit_status(request)
	if request.data.status == "success" then
		return { msg = "Completed", level = "info", icon = " " }
	elseif request.data.status == "error" then
		return { msg = "Error", level = "error", icon = " " }
	else
		return { msg = "Cancelled", level = "info", icon = "󰜺 " }
	end
end

return M
