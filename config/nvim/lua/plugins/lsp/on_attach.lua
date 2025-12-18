---@param event vim.api.keyset.create_autocmd.callback_args
---@return boolean?
local function on_attach(event)
	-- NOTE: Remember that Lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	---@param keys string Left-hand side |{lhs}| of the mapping.
	---@param func string|function Right-hand side |{rhs}| of the mapping, can be a Lua function.
	---@param opts? vim.keymap.set.Opts
	---@param mode? string|string[] Mode "short-name" (see |nvim_set_keymap()|), or a list thereof.
	local function map(keys, func, opts, mode)
		mode = mode or "n"
		opts.buffer = event.buf
		vim.keymap.set(mode, keys, func, opts)
	end

	-- Jump to the definition of the word under your cursor.
	--  This is where a variable was first declared, or where a function is defined, etc.
	--  To jump back, press <C-t>.

	-- lsp keybinds
	map("gd", Snacks.picker.lsp_definitions, { desc = "[G]oto [D]efinition" })
	map("gD", Snacks.picker.lsp_declarations, { desc = "[G]oto [D]eclaration" })
	map("gr", Snacks.picker.lsp_references, { nowait = true, desc = "[R]eferences" })
	map("gI", Snacks.picker.lsp_implementations, { desc = "Goto [I]mplementation" })
	map("gy", Snacks.picker.lsp_type_definitions, { desc = "Goto T[y]pe Definition" })
	map("<leader>ss", Snacks.picker.lsp_symbols, { desc = "LSP [S]ymbols" })
	map("<leader>sS", Snacks.picker.lsp_workspace_symbols, { desc = "LSP Workspace [S]ymbols" })
	map("gd", vim.lsp.buf.definition, { desc = "[G]oto [D]efinition" })
	-- map("gD", vim.lsp.buf.declaration, { desc = "[G]oto [D]eclaration" })
	-- map("gr", vim.lsp.buf.references, { nowait = true, desc = "[R]eferences" })

	-- Rename the variable under your cursor.
	--  Most Language Servers support renaming across files, etc.
	map("<leader>cr", vim.lsp.buf.rename, { desc = "[C]ode [R]ename" })

	-- Execute a code action, usually your cursor needs to be on top an error
	-- or a suggestion from your LSP for this to activate.
	map("<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" }, { "n", "x" })

	-- The following autocommands are used to highlight references of the
	-- word under your cursor when your cursor rests there for a little while.
	--    See `:help CursorHold` for information about when this is executed
	--
	-- When you move your cursor, the highlights will be cleared (the second autocommand).
	local client = vim.lsp.get_client_by_id(event.data.client_id)
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

	-- The following code creates a keymap to toggle inlay hints in your
	-- code, if the language server you are using supports them
	--
	-- This may be unwanted, since they displace some of your code
	if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
		map("<leader>ch", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
		end, { desc = "Toggle Inlay [C]ode [H]ints" })
	end
end

---@module "lazy"
---@type LazyPluginSpec
return {
	"neovim/nvim-lspconfig",
	optional = true,
	dependencies = {
		-- UI for actions
		"folke/snacks.nvim",
	},
	opts_extend = { "setup_extend" },
	opts = {
		---@type fun(self:LazyPlugin, opts:table)[]
		-- Will be executed when loading the plugin
		setup_extend = {
			function(_, _)
				--  This function gets run when an LSP attaches to a particular buffer.
				--    That is to say, every time a new file is opened that is associated with
				--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
				--    function will be executed to configure the current buffer
				vim.api.nvim_create_autocmd("LspAttach", {
					group = vim.api.nvim_create_augroup("lazy-lsp-attach", { clear = true }),
					callback = on_attach,
				})
			end,
		},
	},
}
