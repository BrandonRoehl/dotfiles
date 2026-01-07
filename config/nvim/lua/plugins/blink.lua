-- Autocompletion
---@module "lazy"
---@return LazyPluginSpec
return {
	"saghen/blink.cmp",
	-- Use a release tag to download pre-built binaries
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',
	--
	version = "*",
	-- Make sure the plugin is loaded before LSP config enable so it can set
	-- capabilities properly
	-- blink.cmp/plugin/blink-cmp.lua
	lazy = true,
	event = { "InsertEnter", "CmdlineEnter", "LspPreEnable" },
	cmd = { "BlinkCmp" },
	-- Optional: provides snippets for the snippet source
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	-- `opts_extend` can be a list of dotted keys that will be extended instead of merged
	opts_extend = { "sources.default", "completion.menu.draw.treesitter" },
	--- @module 'blink.cmp'
	--- @type blink.cmp.Config
	opts = {
		-- 'default' for mappings similar to built-in completion
		-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
		-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
		-- See the full "keymap" documentation for information on defining your own keymap.
		keymap = {
			preset = "default",

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

			-- Tab completion
			-- ['<Tab>'] = { 'snippet_forward', 'fallback' },
			-- ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

			-- Enter will insert whether is selected
			-- or enter if nothing is yet
			["<CR>"] = { "accept", "fallback" },
			-- Tab will accept the ghost text or the selection first
			["<Tab>"] = {
				-- If there is something selected accept it
				"accept",
				-- If there is nothing selected and a running snippet jump forward in the snippet
				"snippet_forward",
				-- If there is an inline completion available, select and accept it (nvim 0.12+)
				function(_)
					return vim.fn.has("nvim-0.12") == 1 and vim.lsp.inline_completion.get()
				end,
				-- If nothing so far is true but there is a menu select the first thing
				"select_and_accept",
				-- If there is actually nothing trigger the normal key
				"fallback",
			},
			["<S-Tab>"] = { "snippet_backward", "fallback" },

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
			default = { "lsp", "path", "snippets" },
			-- default = { "lsp", "path", "snippets", "buffer" },
		},
		-- Completion behavior
		completion = {
			ghost_text = {
				enabled = true,
				-- Show the ghost text when the menu is open
				show_with_menu = true,
				-- Show the ghost text even if the menu isn't open
				show_without_menu = false,
				-- Show the ghost text when an item has been selected
				show_with_selection = true,
				-- Show the ghost text when no item has been selected, defaulting to the first item
				show_without_selection = false,
			},
			documentation = {
				-- Controls whether the documentation window will automatically show when selecting a completion item
				auto_show = true,
				-- Delay before showing the documentation window
				auto_show_delay_ms = 500,
				-- Delay before updating the documentation window when selecting a new item,
				-- while an existing item is still visible
				update_delay_ms = 50,
				-- Whether to use treesitter highlighting, disable if you run into performance issues
				treesitter_highlighting = true,
				-- Window borders to easier see
				window = { border = vim.g.winborder },
			},
			list = {
				selection = {
					preselect = false,
					-- preselect = function(ctx)
					-- 	return ctx.mode ~= "cmdline"
					-- 	-- return ctx.mode ~= "cmdline" and not require("blink.cmp").snippet_active({ direction = 1 })
					-- end,
					auto_insert = false,
					-- auto_insert = function(ctx)
					-- 	return ctx.mode ~= "cmdline"
					-- end,
				},
			},
			menu = {
				auto_show = true,
				draw = {
					treesitter = { "lsp" },
					columns = not vim.g.have_nerd_font and {
						{ "label", "label_description", gap = 1 },
						{ "kind" },
					} or nil,
				},
				-- Window borders to easier see
				border = vim.g.winborder,
			},
		},
		-- Show the signature help when typing
		signature = {
			enabled = true,
			trigger = {
				-- Show the signature help automatically
				enabled = true,
				-- Show the signature help window after typing any of alphanumerics, `-` or `_`
				show_on_keyword = false,
				blocked_trigger_characters = {},
				blocked_retrigger_characters = {},
				-- Show the signature help window after typing a trigger character
				show_on_trigger_character = true,
				-- Show the signature help window when entering insert mode
				show_on_insert = true,
				-- Show the signature help window when the cursor comes after a trigger character when entering insert mode
				show_on_insert_on_trigger_character = true,
			},
			-- Window borders to easier see
			window = { border = vim.g.winborder },
		},

		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	-- init is called on parsing of the plugin spec thus this just sets up the
	-- config command for the LSPs when they load
}
