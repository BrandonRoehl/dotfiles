local M = {}

function M:create_autocmds()
	vim.schedule(function()
		local group = vim.api.nvim_create_augroup("lazy-lsp-progress", { clear = true })

		require("plugins.lsp.progress.snacks"):create_autocmd(group)
		require("plugins.lsp.progress.ghostty"):create_autocmd(group)
	end)
end

return M
