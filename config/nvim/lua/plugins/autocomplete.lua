-- Autocompletion
return {
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		-- optional: provides snippets for the snippet source
		dependencies = "rafamadriz/friendly-snippets",

		-- use a release tag to download pre-built binaries
		version = "*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- See the full "keymap" documentation for information on defining your own keymap.
			keymap = {
				preset = "enter",

				-- Default mappings
				-- ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
				-- ['<C-e>'] = { 'cancel', 'fallback' },
				-- ['<C-y>'] = { 'select_and_accept' },

				-- Select the [p]revious item
				-- ['<C-p>'] = { 'select_prev', 'fallback' },
				-- ['<Up>'] = { 'select_prev', 'fallback' },

				-- Select the [n]ext item
				-- ['<C-n>'] = { 'select_next', 'fallback' },
				-- ['<Down>'] = { 'select_next', 'fallback' },

				-- Scroll the documentation window [b]ack / [f]orward
				-- ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
				-- ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

				-- unbinding tab this now goes to copilot if you remove copilot
				-- add this back
				["<Tab>"] = {},
				["<S-Tab>"] = {},
				-- ['<Tab>'] = { 'snippet_forward', 'fallback' },
				-- ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

				-- ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },

				-- Accept ([y]es) the completion.
				--  This will auto-import if your LSP supports it.
				--  This will expand snippets if the LSP sent a snippet.

				-- cmdline = {
				-- 	-- disable enter for the cmdline completion
				-- 	["<CR>"] = {},
				-- },
			},

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- Will be removed in a future release
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
				},
				list = {
					selection = {
						preselect = function(ctx)
							return ctx.mode ~= "cmdline"
							-- return ctx.mode ~= "cmdline" and not require("blink.cmp").snippet_active({ direction = 1 })
						end,
						auto_insert = true,
						-- auto_insert = function(ctx)
						-- 	return ctx.mode ~= "cmdline"
						-- end,
					},
				},
				menu = {
					draw = vim.g.have_nerd_font and {} or {
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind" },
						},
					},
				},
			},
		},
		opts_extend = { "sources.default" },
	},
}
