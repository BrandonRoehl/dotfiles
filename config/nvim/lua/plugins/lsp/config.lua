---@module "plugins.lsp"
---@param client vim.lsp.Client
---@param bufnr integer
local bind_keys = vim.schedule_wrap(function(client, bufnr)
	local opts = Utils.lazy:plugin_opts("nvim-lspconfig")
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
end)

---@param event vim.api.keyset.create_autocmd.callback_args
---@return boolean?
local function on_attach(event)
	local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
	bind_keys(client, event.buf)

	-- The following auto commands trigger the diagnostics for what you are hovering
	vim.api.nvim_create_autocmd("CursorHold", {
		buffer = event.buf,
		callback = function()
			-- Check if there are any visible floating windows already
			-- for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			-- 	if vim.api.nvim_win_get_config(win).relative ~= "" then
			-- 		-- A float exists, don't create another one
			-- 		return
			-- 	end
			-- end

			vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
		end,
	})

	-- Auto-format ("lint") on save.
	-- Usually not needed if server supports "textDocument/willSaveWaitUntil".
	if
		not client:supports_method(vim.lsp.protocol.Methods.textDocument_willSaveWaitUntil, event.buf)
		and client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting, event.buf)
	then
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("lsp_document_lint", { clear = false }),
			buffer = event.buf,
			callback = function()
				vim.lsp.buf.format({ bufnr = event.buf, id = client.id, timeout_ms = 1000 })
			end,
		})
	end

	if
		vim.fn.has("nvim-0.12") == 1
		and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, event.buf)
	then
		vim.lsp.inline_completion.enable(true, { bufnr = event.buf })
	end
end

---@module "lazy"
---@type LazyPluginSpec
return {
	"neovim/nvim-lspconfig",
	optional = true,
	---@param _ LazyPlugin
	---@param opts LspOptions
	config = vim.schedule_wrap(function(_, opts)
		-- Trigger pre enable after servers are configured
		--
		Utils.lazy.trigger_custom_event("LspPreEnable")

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
		-- Still bugs around `vim.o.winborder`
		-- waiting on mason and snacks to remove this
		if vim.g.winborder then
			-- To override globally the opts if none are provided
			-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#borders
			local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or vim.g.winborder
				return orig_util_open_floating_preview(contents, syntax, opts, ...)
			end
		end
		-- Configure diagnostics
		vim.diagnostic.config(opts.diagnostics)

		--https://neovim.io/doc/user/lsp.html#lsp-config-merge
		-- The configuration that is used will be merging keeping keys
		-- 1. `nvim/lsp/name.lua`
		--   - provided by "nvim-lspconfig"
		-- 2. `nvim/lsp/after/name.lua`
		--   - custom overrides for your config
		-- 3. `{ opts.servers.name }`
		--   - extra features provided by plugins
		-- First apply any custom configuration provided by plugins
		for server, config in pairs(opts.servers or {}) do
			if not vim.tbl_isempty(config) then
				vim.lsp.config(server, config)
			end
		end
		-- Enable all servers that have provided keys
		local enable = vim.tbl_filter(function(server)
			return server ~= "*"
		end, vim.tbl_keys(opts.servers or {}))
		if #enable > 0 then
			vim.lsp.enable(enable)
		end
		Utils.lazy.trigger_custom_event("LspPostEnable")
	end),
}
