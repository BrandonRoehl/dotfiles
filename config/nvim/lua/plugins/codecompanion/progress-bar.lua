local M = {}

function M:init()
	local group = vim.api.nvim_create_augroup("CodeCompanionProgressHooks", { clear = true })

	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = "CodeCompanionRequestStarted",
		group = group,
		callback = function(request)
			io.stdout:write("\x1b]9;4;3;0\x07")
		end,
	})

	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = "CodeCompanionRequestFinished",
		group = group,
		callback = function(request)
			io.stdout:write("\x1b]9;4;0;0\x07")
		end,
	})
end

return M
