local M = {}

function M:init()
	local group = vim.api.nvim_create_augroup("CodeCompanionProgressHooks", { clear = true })

	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = "CodeCompanionRequestStarted",
		group = group,
		callback = function(request)
			io.stdout:write("\x1B]9;4;3\x1B\x5C")
		end,
	})

	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = "CodeCompanionRequestFinished",
		group = group,
		callback = function(request)
			io.stdout:write("\x1B]9;4;0\x1B\x5C")
		end,
	})
end

return M
