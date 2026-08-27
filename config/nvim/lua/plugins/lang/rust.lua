---@module "lazy"

--- Show `lines` in a scratch float anchored to the cursor, dismissed on any cursor move.
---@param title string
---@param lines string[]
local function open_cursor_float(title, lines)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.bo[buf].bufhidden = "wipe"
	-- Highlight without setting 'filetype' so no LSP/ftplugin attaches to the scratch buffer.
	pcall(vim.treesitter.start, buf, "rust")

	local width = 1
	for _, line in ipairs(lines) do
		width = math.max(width, vim.fn.strdisplaywidth(line))
	end
	width = math.max(math.min(width, math.floor(vim.o.columns * 0.8)), #title + 4)
	local height = math.min(#lines, math.floor(vim.o.lines * 0.6))

	local win = vim.api.nvim_open_win(buf, false, {
		relative = "cursor",
		row = 1,
		col = 0,
		width = width,
		height = math.max(height, 1),
		style = "minimal",
		border = "rounded",
		title = " " .. title .. " ",
		title_pos = "center",
	})
	vim.wo[win].wrap = false
	vim.wo[win].conceallevel = 0

	-- Defer so events fired while opening the window don't close it immediately.
	vim.schedule(function()
		if not vim.api.nvim_win_is_valid(win) then
			return
		end
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertEnter", "BufLeave", "WinLeave" }, {
			group = vim.api.nvim_create_augroup("rust_expand_macro_float", { clear = true }),
			once = true,
			callback = function()
				if vim.api.nvim_win_is_valid(win) then
					vim.api.nvim_win_close(win, true)
				end
			end,
		})
	end)
end

local function expand_macro()
	local client = vim.lsp.get_clients({ bufnr = 0, name = "rust_analyzer" })[1]
	if not client then
		vim.notify("rust-analyzer is not attached to this buffer", vim.log.levels.WARN)
		return
	end

	local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
	client:request("rust-analyzer/expandMacro", params, function(err, result)
		if err then
			vim.notify("Expand macro failed: " .. (err.message or vim.inspect(err)), vim.log.levels.ERROR)
			return
		end
		if not result or not result.expansion or result.expansion == "" then
			vim.notify("No macro under cursor", vim.log.levels.INFO)
			return
		end
		open_cursor_float(result.name or "Macro expansion", vim.split(result.expansion, "\n", { trimempty = true }))
	end, 0)
end

---@return LazyPluginSpec[]
return {
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts = {
			ensure_installed = { "rust", "ron" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts = {
			servers = {
				rust_analyzer = {
					keys = {
						{
							"<leader>cx",
							expand_macro,
							desc = "Expand macro",
						},
					},
				},
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		optional = true,
		opts = {
			ensure_installed = { "rust_analyzer" },
		},
	},
	-- {
	-- 	"mason-org/mason.nvim",
	-- 	optional = true,
	-- 	opts = {
	-- 		ensure_installed = { "rustfmt" },
	-- 	},
	-- },
	-- {
	-- 	"stevearc/conform.nvim",
	-- 	optional = true,
	-- 	opts = {
	-- 		formatters_by_ft = {
	-- 			rust = { "rustfmt" },
	-- 		},
	-- 	},
	-- },
}
