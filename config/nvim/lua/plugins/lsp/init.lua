-- Brief aside: **What is LSP?**
--
-- LSP is an initialism you've probably heard, but might not understand what it is.
--
-- LSP stands for Language Server Protocol. It's a protocol that helps editors
-- and language tooling communicate in a standardized fashion.
--
-- In general, you have a "server" which is some tool built to understand a particular
-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
-- processes that communicate with some "client" - in this case, Neovim!
--
-- LSP provides Neovim with features like:
--  - Go to definition
--  - Find references
--  - Autocompletion
--  - Symbol Search
--  - and more!
--
-- Thus, Language Servers are external tools that must be installed separately from
-- Neovim. This is where `mason` and related plugins come into play.
--
-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
-- and elegantly composed help section, `:help lsp-vs-treesitter`

---@class LazyKeysLspSpec: LazyKeysSpec,snacks.keymap.set.Opts
---@field method? string|string[] lsp methods that allow this to bind
---@class LazyKeysLsp: LazyKeys
---@field method? string|string[] lsp methods that allow this to bind

---@param client vim.lsp.Client
---@param bufnr integer
local function bind_keys(client, bufnr)
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

---@class LspServerConfig: vim.lsp.Config
---@field keys? LazyKeysLspSpec[]

---@module "lazy"
---@type LazyPluginSpec
return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	import = "plugins.lsp",
	lazy = true,
	event = { "BufReadPost", "BufNewFile", "VeryLazy" },
	cmd = { "LspInfo", "LspInstall", "LspUninstall" },
	-- `opts_extend` can be a list of dotted keys that will be extended instead of merged
	opts_extend = { "servers.*.keys" },
	---@class LspOptions configs to change when the popup is shown
	opts = {
		---@type table<string, LspServerConfig?>
		servers = {},
		---@type vim.diagnostic.Opts
		diagnostics = {},
	},
	---@param plugin LazyPlugin
	---@param opts LspOptions
	config = function(_, opts)
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
			vim.lsp.config(server, config)
		end
		-- Trigger pre enable after servers are configured
		--
		Utils:trigger_custom_event("LspPreEnable")

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
		-- Enable all servers that have provided keys
		local enable = vim.tbl_filter(function(server)
			return server ~= "*"
		end, vim.tbl_keys(opts.servers or {}))
		if #enable > 0 then
			vim.lsp.enable(enable)
		end
		Utils:trigger_custom_event("LspPostEnable")

		require("plugins.lsp.progress.callbacks"):create_autocmds()
	end,
}
