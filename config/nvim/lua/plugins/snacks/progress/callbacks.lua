local M = {}

function M.create_autocmds()
	vim.schedule(function()
		local group = vim.api.nvim_create_augroup("lazy-lsp-progress", { clear = true })

		require("plugins.snacks.progress.notify").create_autocmd(group)
		require("plugins.snacks.progress.ghostty").create_autocmd(group)
	end)
end

return M
