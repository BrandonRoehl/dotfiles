---@param client vim.lsp.Client
---@param bufnr integer
function bind_keys(client, bufnr)
	local opts = Utils:plugin_opts("nvim-lspconfig")
	---@type LazyKeysSpec[]
	local global_spec = vim.tbl_get(opts, "servers", "*", "keys") or {}
	---@type LazyKeysSpec[]
	local server_spec = vim.tbl_get(opts, "servers", client.name, "keys") or {}
	---@type LazyKeysSpec[]
	local spec = vim.list_extend(vim.deepcopy(server_spec), vim.deepcopy(global_spec))

	local LazyKeys = require("lazy.core.handler.keys")
	for _, keys in pairs(LazyKeys.resolve(spec)) do
		---@cast keys LazyKeysLsp
		local opts = LazyKeys.opts(keys)
		---@cast opts vim.keymap.set.Opts
		opts.buffer = bufnr
		opts.method = nil

		---@type boolean
		local should_bind = true
		if keys.method then
			-- Methods where provided if they are not present do not bind
			local methods = type(keys.method) == "string" and { keys.method } or keys.method --[[@as string[] ]]
			should_bind = vim.tbl_contains(methods, function(method)
				return client:supports_method(method, bufnr)
			end, { predicate = true })
		end

		if should_bind then
			vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
		end
	end
end

---@param event vim.api.keyset.create_autocmd.callback_args
---@return boolean?
local function on_attach(event)
	local client = vim.lsp.get_client_by_id(event.data.client_id)
	if not client then
		return
	end
	bind_keys(client, event.buf)

	-- The following autocommands are used to highlight references of the
	-- word under your cursor when your cursor rests there for a little while.
	--    See `:help CursorHold` for information about when this is executed
	--
	-- When you move your cursor, the highlights will be cleared (the second autocommand).
	if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
		-- vim.cmd([[
		-- hi! LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
		-- hi! LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
		-- hi! LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
		-- ]])
		vim.api.nvim_create_augroup("lsp_document_highlight", {
			clear = false,
		})
		vim.api.nvim_clear_autocmds({
			buffer = event.buf,
			group = "lsp_document_highlight",
		})
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = "lsp_document_highlight",
			buffer = event.buf,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			group = "lsp_document_highlight",
			buffer = event.buf,
			callback = vim.lsp.buf.clear_references,
		})
	end

	-- The following auto commands trigger the diagnostics for what you are hovering
	vim.api.nvim_create_autocmd("CursorHold", {
		buffer = event.buf,
		callback = function()
			-- Check if there are any visible floating windows already
			-- for _, win in ipairs(vim.api.nvim_list_wins()) do
			-- 	if vim.api.nvim_win_get_config(win).relative ~= "" then
			-- 		-- A float exists, don't create another one
			-- 		return
			-- 	end
			-- end

			vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
		end,
	})
end

---@module "lazy"
---@type LazyPluginSpec
return {
	"neovim/nvim-lspconfig",
	optional = true,
	opts_extend = { "setup_extend" },
	opts = {
		---@type fun(self:LazyPlugin, opts:table)[]
		-- Will be executed when loading the plugin
		setup_extend = {
			function(_, _)
				--  This function gets run when an LSP attaches to a particular buffer.
				--    That is to say, every time a new file is opened that is associated with
				--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
				--    function will be executed to configure the current buffer.
				--
				--  This is enabled as this instead of `on_attach` in lspconfig so it will
				--  fire for all LSPs even those with a separate `on_attach`
				vim.api.nvim_create_autocmd("LspAttach", {
					group = vim.api.nvim_create_augroup("lazy-lsp-attach", { clear = true }),
					callback = on_attach,
				})
			end,
		},
	},
}
